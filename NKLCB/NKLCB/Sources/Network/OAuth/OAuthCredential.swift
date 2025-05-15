import Alamofire
import Foundation

struct OAuthCredential: AuthenticationCredential {
    let accessToken: String
    let refreshToken: String
    let expiredAt: Date
    
    // 유효시간이 24시간 이하로 남았다면 refresh가 필요하다고 true를 리턴 (false를 리턴하면 refresh 필요x)
    var requiresRefresh: Bool { Date(timeIntervalSinceNow: 60 * 60) > expiredAt }
}
