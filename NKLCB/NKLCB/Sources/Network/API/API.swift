public protocol API {
    var baseURL: String { get }
    var method: Method { get }
    var path: String { get }
    var parameters: [String: String]? { get }
}

public enum Method: String {
    case get = "GET"
    case post = "POST"
}
