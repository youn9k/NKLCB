import Alamofire
import Foundation

public final class NetworkService {
    public static let shared = NetworkService()
    private let keyChain = KeyChain.shared
    private let authQueue = DispatchQueue(label: "authQueue")
    private let networkLogger: NetworkLogger
    private var session: Session
    
    private init() {
        // load token
        let accessToken = keyChain.load(type: .accessToken) ?? ""
        let refreshToken = keyChain.load(type: .refreshToken) ?? ""
        var expiresIn = Date(timeIntervalSinceNow: 60 * 60 * 24) // default
        
        if let exp = Double(keyChain.load(type: .accessExpiresIn) ?? "") {
            expiresIn = exp.unixTimeToDate
        }
        
        // Create credential and session
        let authenticator = OAuthAuthenticator()
        let credential = OAuthCredential(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiredAt: expiresIn
        )
        
        let interceptor = AuthenticationInterceptor(
            authenticator: authenticator,
            credential: credential
        )
        
        self.networkLogger = NetworkLogger()
        
        self.session = Session(
            interceptor: interceptor,
            eventMonitors: [networkLogger]
        )
    }
    
    public func request<T: Decodable>(_ api: API) async -> Result<T, Error> {
        let url = api.baseURL + "/" + api.path
        let httpMethod = HTTPMethod(rawValue: api.method.rawValue)
        
        let task: DataTask<T> = session.request(url, method: httpMethod, parameters: api.parameters)
            .validate()
            .serializingDecodable(T.self)
        
        let response = await task.response
        switch response.result {
        case .success(let data): return .success(data)
        case .failure(let error): return .failure(error)
        }
    }
    
    public func request<T: Decodable>(_ api: API) async throws -> T {
        let url = api.baseURL + "/" + api.path
        let httpMethod = HTTPMethod(rawValue: api.method.rawValue)
        
        let task: DataTask<T> = session.request(url, method: httpMethod, parameters: api.parameters)
            .validate()
            .serializingDecodable(T.self)
        
        let response = await task.response
        switch response.result {
        case .success(let data): return data
        case .failure(let error): throw error
        }
    }
    
    public func requestWithoutAuth<T: Decodable>(_ api: API) async -> Result<T, Error> {
        let url = api.baseURL + "/" + api.path
        let httpMethod = HTTPMethod(rawValue: api.method.rawValue)
        
        let task: DataTask<T> = AF.request(url, method: httpMethod, parameters: api.parameters)
            .validate()
            .serializingDecodable(T.self)
        
        let response = await task.response
        switch response.result {
        case .success(let data): return .success(data)
        case .failure(let error): return .failure(error)
        }
    }
    
    public func requestWithoutAuth<T: Decodable>(_ api: API) async throws -> T {
        let url = api.baseURL + "/" + api.path
        let httpMethod = HTTPMethod(rawValue: api.method.rawValue)
        
        let task: DataTask<T> = AF.request(url, method: httpMethod, parameters: api.parameters)
            .validate()
            .serializingDecodable(T.self)
        
        let response = await task.response
        switch response.result {
        case .success(let data): return data
        case .failure(let error): throw error
        }
    }
    
    public func updateCredentials() {
        authQueue.async { [weak self] in
            guard let self else { return }
            
            let accessToken = keyChain.load(type: .accessToken) ?? ""
            let refreshToken = keyChain.load(type: .refreshToken) ?? ""
            var expiredAt = Date(timeIntervalSinceNow: 60 * 60 * 24) // default
            
            if let exp = Double(keyChain.load(type: .accessExpiredAt) ?? "") {
                expiredAt = exp.unixTimeToDate
            }
            
            // Create credential and session
            let authenticator = OAuthAuthenticator()
            let credential = OAuthCredential(
                accessToken: accessToken,
                refreshToken: refreshToken,
                expiredAt: expiredAt
            )
            
            let interceptor = AuthenticationInterceptor(
                authenticator: authenticator,
                credential: credential
            )
            print("🛰 Session 업데이트 - Access Token: \(accessToken)")
            print("🛰 Session 업데이트 - Refresh Token: \(refreshToken)")
            
            self.session = Session(
                interceptor: interceptor,
                eventMonitors: [self.networkLogger]
            )
        }
    }
}
