import Foundation

public func config(key: String) -> String? {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets[key] as? String
}

public func BASE_URL() -> String? {
    return config(key: "BASE_URL")
}

public func RECRUIT_BASE_URL() -> String? {
    return config(key: "RECRUIT_BASE_URL")
}
