import Foundation
import Security

public final class KeyChain: Sendable {
    public static let shared = KeyChain()
    private let service: String = Bundle.main.bundleIdentifier ?? ""
    
    private init() {}

    public func save(type: KeyChainType, value: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: type.rawValue,
            kSecValueData: value.data(using: .utf8, allowLossyConversion: false) ?? .init()
        ]
        SecItemDelete(query)
        SecItemAdd(query, nil)
    }

    public func load(type: KeyChainType) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: type.rawValue,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            guard let data = dataTypeRef as? Data else { return nil }
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    public func delete(type: KeyChainType) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: type.rawValue
        ]
        SecItemDelete(query)
    }
}
