public protocol AuthRepository {
    func socialLogin(providerType: ProviderType, token: String) async throws -> SocialLoginResponseDTO
}
