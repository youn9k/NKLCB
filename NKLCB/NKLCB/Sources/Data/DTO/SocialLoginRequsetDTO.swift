import Foundation

public struct SocialLoginRequsetDTO: Encodable {
    public let providerType: ProviderType
    public let token: String
    
    public init(providerType: ProviderType, token: String) {
        self.providerType = providerType
        self.token = token
    }
}

public enum ProviderType: String, Encodable {
    case apple
}




