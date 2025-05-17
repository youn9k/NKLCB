import Foundation

enum AuthAPI: API {
    case loginWithOAuth(_ body: SocialLoginRequsetDTO)
    case renewAccessToken(_ body: TokenRefreshRequestDTO)
    case logout(_ body: LogoutRequestDTO)

    private static let domain = "/auth"
    
    var baseURL: String {
        config(key: "BASE_URL") ?? ""
    }

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

    var parameters: [String : String]? {
       return nil
    }
}
