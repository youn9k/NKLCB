import Foundation

struct CachedDateFormatter {
    private static var cache: [String: DateFormatter] = [:]

    static func string(_ date: Date?, format: String) -> String? {
        guard let date else { return nil }

        for format in withFallbackFormats(first: format) {
            return cachedFormatter(format: format).string(from: date)
        }

        return nil
    }
    
    static func date(_ string: String?, format: String) -> Date? {
        guard let string else { return nil }

        for format in withFallbackFormats(first: format) {
            if let date = cachedFormatter(format: format).date(from: string) {
                return date
            }
        }

        return nil
    }
    
    private static func withFallbackFormats(first preferred: String) -> [String] {
        var formats = [preferred]
        
        let fallbackFormats = [
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd HH:mm",
            "yyyy-MM-dd"
        ]
        
        formats.append(contentsOf: fallbackFormats)
        return formats
    }

    private static func cachedFormatter(format: String) -> DateFormatter {
        if let cachedFormatter = cache[format] { return cachedFormatter }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = format
        cache[format] = formatter
        return formatter
    }
}
