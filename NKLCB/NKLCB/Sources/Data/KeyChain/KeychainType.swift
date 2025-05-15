public enum KeyChainType: String, Sendable {
    case accessToken = "ACCESS-TOKEN"
    case refreshToken = "REFRESH-TOKEN"
    case accessExpiresIn = "ACCESS-EXPIRES-IN" // 토큰이 만료될 시간을 Miliseconds(timestamp)로 저장해요
    case deviceID = "DEVICE-ID"
}
