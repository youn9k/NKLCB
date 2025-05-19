import Foundation

public struct LogoutRequestDTO: Encodable {
  public let refreshToken: String
  
  public init(refreshToken: String) {
    self.refreshToken = refreshToken
  }
}
