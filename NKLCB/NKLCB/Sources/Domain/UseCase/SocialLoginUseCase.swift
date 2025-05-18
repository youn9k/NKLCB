public protocol SocialLoginUseCase {
    func execute(providerType: ProviderType, token: String) async throws -> SocialLoginResponseDTO
}

public final class SocialLoginUseCaseImpl: SocialLoginUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func execute(providerType: ProviderType, token: String) async throws -> SocialLoginResponseDTO {
        return try await repository.socialLogin(providerType: providerType, token: token)
    }
}
