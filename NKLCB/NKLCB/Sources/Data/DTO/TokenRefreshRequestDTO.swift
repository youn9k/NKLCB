import Foundation

public struct TokenRefreshRequestDTO: Encodable {
  public let refreshToken: String
  
  public init(refreshToken: String) {
    self.refreshToken = refreshToken
  }
}
