import AuthenticationServices

public protocol AppleAuthServiceUseCase {
  func execute() async throws -> AppleAuthResultEntity
}

public final class AppleAuthServiceUseCaseImpl: NSObject, AppleAuthServiceUseCase {
    private let appleAuthDomain = "\(Bundle.main.bundleIdentifier ?? "").AppleAuth"
    private var continuation: CheckedContinuation<AppleAuthResultEntity, Error>?
    private var authController: ASAuthorizationController?
    
    public func execute() async throws -> AppleAuthResultEntity {
        guard continuation == nil else {
            throw NSError(
                domain: appleAuthDomain,
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "이미 요청이 진행 중입니다."])
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            self.authController = controller
            controller.delegate = self
            controller.performRequests()
        }
    }
}

extension AppleAuthServiceUseCaseImpl: ASAuthorizationControllerDelegate {
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
          let authorizationCodeData = appleIDCredential.authorizationCode,
          let authorizationCode = String(data: authorizationCodeData, encoding: .utf8)
    else {
        continuation?.resume(throwing: NSError(
            domain: appleAuthDomain,
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Invalid Credential"])
        )
      return
    }
    
    let result = AppleAuthResultEntity(
      authorizationCode: authorizationCode,
      email: appleIDCredential.email
    )
    continuation?.resume(returning: result)
  }
  
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    continuation?.resume(throwing: error)
  }
}
