import Foundation

struct RecruitEntity: Equatable {
    let id: Int                             // 고유 ID (예: "-8164133446")
    let companyCode: CompanyCode            // 회사 코드 (예: "NAVER", "KAKAO")
    let announcementID: Int                 // 공고 ID (예: 150420)
    let jobCategory: String?                // 직무 분류명 (예: "Tech", "Engineering", "R&D")
    let jobType: JobType                    // 고용 형태 (예: "정규", "인턴", "기간제")
    let title: String                       // 공고 제목 (예: "뉴스 서비스 플랫폼 BE 개발 (경력)")
    let positionType: String                // 포지션 유형 (예: "BE", "PM", "DataAnalyst")
    let detailedCompanyName: String         // 세부 회사명 (예: "토스증권", "당근페이")
    let detailPageURL: String               // 상세 페이지 링크 (예: "https://...")
    let workplace: Workplace                // 근무 위치 (예: "서울")
    let recruitPeriod: RecruitPeriod        // 채용 기간 (상시, 채용시 마감, 기한)
    
    static func == (lhs: RecruitEntity, rhs: RecruitEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
