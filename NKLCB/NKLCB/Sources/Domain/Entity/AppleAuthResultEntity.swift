import Foundation

public struct AppleAuthResultEntity {
  public let authorizationCode: String
  public let email: String?
  
  public init(authorizationCode: String, email: String?) {
    self.authorizationCode = authorizationCode
    self.email = email
  }
}
