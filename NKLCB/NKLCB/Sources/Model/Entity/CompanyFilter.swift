import SwiftUI

enum CompanyFilter: String, CaseIterable, Identifiable {
    case all = "전체"
    case naver = "네이버"
    case kakao = "카카오"
    case line = "라인"
    case coupang = "쿠팡"
    case baemin = "배민"
    case daangn = "당근"
    case toss = "토스"
    case yanolja = "야놀자"
    
    var id: String { self.rawValue }
    
    var queryParameter: String {
        switch self {
        case .all: "ALL"
        case .naver: "NAVER"
        case .kakao: "KAKAO"
        case .line: "LINE"
        case .coupang: "COUPANG"
        case .baemin: "BAEMIN"
        case .daangn: "DAANGN"
        case .toss: "TOSS"
        case .yanolja: "YANOLJA"
        }
    }
    
    /// RecruitEntity 에서 회사명으로 필터링하기 위함
    var companyCode: CompanyCode? {
        switch self {
        case .all: return nil
        case .naver: return .naver
        case .kakao: return .kakao
        case .line: return .line
        case .coupang: return .coupang
        case .baemin: return .baemin
        case .daangn: return .daangn
        case .toss: return .toss
        case .yanolja: return .yanolja
        }
    }
    
    var companyColor: Color {
        switch self {
        case .all: return .gray900
        case .naver: return .naver
        case .kakao: return .kakao
        case .line: return .line
        case .coupang: return .coupang
        case .baemin: return .baemin
        case .daangn: return .daangn
        case .toss: return .toss
        case .yanolja: return .yanolja
        }
    }
}
