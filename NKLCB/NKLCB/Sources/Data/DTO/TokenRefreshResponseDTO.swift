import Foundation

public struct TokenRefreshResponseDTO: Decodable {
    public let accessToken: String
    public let expriredAt: TimeInterval
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "token"
        case expriredAt
    }
}
