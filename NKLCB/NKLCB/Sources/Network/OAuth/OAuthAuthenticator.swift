import Alamofire
import Foundation

final class OAuthAuthenticator: Authenticator {
    private let keyChain = KeyChain.shared
    
    func apply(
        _ credential: OAuthCredential,
        to urlRequest: inout URLRequest
    ) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
    }
    
    func didRequest(
        _ urlRequest: URLRequest,
        with response: HTTPURLResponse,
        failDueToAuthenticationError error: any Error
    ) -> Bool {
        return response.statusCode == 401
    }
    
    func isRequest(
        _ urlRequest: URLRequest,
        authenticatedWith credential: OAuthCredential
    ) -> Bool {
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }
    
    func refresh(
        _ credential: OAuthCredential,
        for session: Session,
        completion: @escaping (Result<OAuthCredential, any Error>) -> Void
    ) {
        guard !credential.refreshToken.isEmpty else {
            print("🛰 Refresh Token 없음")
            keyChain.delete(type: .accessToken)
            keyChain.delete(type: .refreshToken)
            return
        }
        
        print("🛰 토큰 재발급 시도")
        print("🛰 refresh token: \(credential.refreshToken)")
        let body = TokenRefreshRequestDTO(refreshToken: credential.refreshToken)
        let api = AuthAPI.renewAccessToken(body)
        
        let url = api.baseURL + "/" + api.path
        let httpMethod = HTTPMethod(rawValue: api.method.rawValue)
        
        print("🛰 URL: \(url)")
        
        AF.request(url, method: httpMethod, parameters: api.parameters)
            .validate()
            .responseDecodable(of: TokenRefreshResponseDTO.self) { [weak self] response in
                guard let self else { return }
                switch response.result {
                case .success(let data):
                    let accessToken = data.accessToken
                    let accessExpriredAt = data.expiredAt
                    print("🛰 토큰 재발급 성공")
                    print("🛰 AccessToken: \(accessToken)")
                    print("🛰 AccessExpriredAt: \(accessExpriredAt)")
                    
                    keyChain.save(type: .accessToken, value: accessToken)
                    keyChain.save(type: .accessExpiredAt, value: String(accessExpriredAt))
                    
                    let newCredential = OAuthCredential(
                        accessToken: accessToken,
                        refreshToken: keyChain.load(type: .refreshToken) ?? "",
                        accessExpiredAt: accessExpriredAt.unixTimeToDate
                    )
                    completion(.success(newCredential))
                    
                case .failure(let error):
                    print("🛰 토큰 재발급 실패: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}
