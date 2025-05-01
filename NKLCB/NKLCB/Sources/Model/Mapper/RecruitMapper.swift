import Foundation

struct RecruitMapper {
    static func map(dto: [RecruitResponseDTO]) -> [RecruitEntity] {
        return dto.map {
            let parsedStartDate = CachedDateFormatter.date($0.startDate, format: "yyyy-MM-dd HH:mm:ss")
            let parsedEndDate = CachedDateFormatter.date($0.endDate, format: "yyyy-MM-dd HH:mm:ss")
            return RecruitEntity(
                id: $0.id,
                companyCode: $0.companyCode,
                announcementID: $0.announcementID,
                jobCategory: $0.jobCategory,
                jobType: $0.jobType,
                title: $0.title,
                positionType: $0.positionType,
                detailedCompanyName: $0.detailedCompanyName,
                detailPageURL: $0.detailPageURL,
                workplace: $0.workplace,
                recruitPeriod: recruitPeriod(
                    start: parsedStartDate,
                    end: parsedEndDate
                )
            )
        }
    }
    
    static func map(dto: RecruitResponseDTO) -> RecruitEntity {
        let parsedStartDate = CachedDateFormatter.date(dto.startDate, format: "yyyy-MM-dd HH:mm:ss")
        let parsedEndDate = CachedDateFormatter.date(dto.endDate, format: "yyyy-MM-dd HH:mm:ss")
        return RecruitEntity(
            id: dto.id,
            companyCode: dto.companyCode,
            announcementID: dto.announcementID,
            jobCategory: dto.jobCategory,
            jobType: dto.jobType,
            title: dto.title,
            positionType: dto.positionType,
            detailedCompanyName: dto.detailedCompanyName,
            detailPageURL: dto.detailPageURL,
            workplace: dto.workplace,
            recruitPeriod: recruitPeriod(
                start: parsedStartDate,
                end: parsedEndDate
            )
        )
    }

    private static func recruitPeriod(start: Date?, end: Date?) -> RecruitPeriod {
        if let end {
            let endYear = Calendar.current.component(.year, from: end)
            if endYear >= 2099 {
                return .infinity
            } else {
                return .deadline(start: start, end: end)
            }
        }
        return .untilHired
    }
}
