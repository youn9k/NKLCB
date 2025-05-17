public final class AuthRepositoryImpl: AuthRepository {
    private let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func socialLogin(providerType: ProviderType, token: String) async throws -> SocialLoginResponseDTO {
        let body = SocialLoginRequsetDTO(providerType: providerType, token: token)
        let api = AuthAPI.loginWithOAuth(body)
        
        let responseDTO: SocialLoginResponseDTO = try await networkService.request(api)
        
        KeyChain.shared.save(type: .accessToken, value: responseDTO.accessToken)
        KeyChain.shared.save(type: .refreshToken, value: responseDTO.refreshToken)
        KeyChain.shared.save(type: .accessExpiresIn, value: String(responseDTO.expiresIn))
        
        networkService.updateCredentials()
        return responseDTO
    }
}


