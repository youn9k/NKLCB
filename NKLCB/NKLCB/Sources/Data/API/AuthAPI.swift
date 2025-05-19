import Foundation

enum AuthAPI: API {
    case loginWithOAuth(_ body: SocialLoginRequestDTO)
    case renewAccessToken(_ body: TokenRefreshRequestDTO)
    case logout(_ body: LogoutRequestDTO)

    private static let domain = "/auth"
    
    var method: Method {
        switch self {
        case .loginWithOAuth: .post
        case .renewAccessToken: .post
        case .logout: .post
        }
    }
    
    var path: String {
        switch self {
        case .loginWithOAuth: "\(AuthAPI.domain)/login"
        case .renewAccessToken: "\(AuthAPI.domain)/token"
        case .logout: "\(AuthAPI.domain)/logout"
        }
    }
    
    var body: Encodable? {
        switch self {
        case .loginWithOAuth(let body):
            return body
        case .renewAccessToken(let body):
            return body
        case .logout(let body):
            return body
        }
    }
}
