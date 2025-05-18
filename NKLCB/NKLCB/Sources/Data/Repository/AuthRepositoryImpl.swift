public final class AuthRepositoryImpl: AuthRepository {
    private let networkService: NetworkService
    private let keyChain: KeyChain
    
    public init(
        networkService: NetworkService,
        keyChain: KeyChain
    ) {
        self.networkService = networkService
        self.keyChain = keyChain
    }
    
    public func socialLogin(providerType: ProviderType, token: String) async throws -> SocialLoginResponseDTO {
        let body = SocialLoginRequsetDTO(providerType: providerType, token: token)
        let api = AuthAPI.loginWithOAuth(body)
        
        let response: SocialLoginResponseDTO = try await networkService.requestWithoutAuth(api)
        
        keyChain.save(type: .accessToken, value: response.accessToken)
        keyChain.save(type: .refreshToken, value: response.refreshToken)
        keyChain.save(type: .accessExpiredAt, value: String(response.expiredAt))
        
        networkService.updateCredentials()
        return response
    }
    
    public func logout() async throws {
        let refreshToken = keyChain.load(type: .refreshToken) ?? ""
        let body = LogoutRequestDTO(refreshToken: refreshToken)
        let api = AuthAPI.logout(body)
        
        try await networkService.requestWithoutAuth(api)
    }
}


