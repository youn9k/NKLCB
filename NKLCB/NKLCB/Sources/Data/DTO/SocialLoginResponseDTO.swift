import Foundation

public struct SocialLoginResponseDTO: Decodable {
    public let accessToken: String
    public let refreshToken: String
    
    /// 액세스 토큰 만료 시간(초 단위 Unix TimeStamp)
    public let expiresIn: TimeInterval
}
