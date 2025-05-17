import Foundation

enum RecruitPeriod {
    /// 상시 공고 (마감일이 매우 먼 미래일 경우)
    case infinity
    
    /// 채용 시 마감 (마감일이 없는 경우)
    case untilHired
    
    /// 마감 기한이 있는 경우
    case deadline(start: Date?, end: Date)
}
