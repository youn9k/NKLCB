import Alamofire
import Foundation

struct OAuthCredential: AuthenticationCredential {
    let accessToken: String
    let refreshToken: String
    let accessExpiredAt: Date
       
    // 액세스 토큰 만료까지 5분 이내라면 미리 액세스 토큰 갱신
    var requiresRefresh: Bool {
        let threshold = Date(timeIntervalSinceNow: 60 * 5)
        return accessExpiredAt < threshold
    }
}
