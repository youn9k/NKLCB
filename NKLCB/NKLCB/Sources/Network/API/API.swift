import Foundation

public protocol API {
    var baseURL: String { get }
    var method: Method { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var parameters: [String: String]? { get }
    var body: Encodable? { get }
}

public extension API {
    var baseURL: String {
        config(key: "BASE_URL") ?? ""
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
    
    var parameters: [String: String]? {
        return nil
    }
    
    var body: Encodable? {
        return nil
    }
}

public enum Method: String {
    case get = "GET"
    case post = "POST"
}

public extension API {
    func asURLRequest() throws -> URLRequest {
        if baseURL.isEmpty || baseURL.last == "/" || !path.hasPrefix("/") {
            throw URLError(.badURL)
        }
        
        var urlComponents = URLComponents(string: baseURL + path)
        
        if let queryParams = parameters {
            urlComponents?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents?.url else { throw URLError(.badURL) }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        if let headers {
            headers.forEach { key, value in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body {
            let bodyData = try JSONEncoder().encode(body)
            urlRequest.httpBody = bodyData
        }
        
        return urlRequest
    }
}
