import XCTest
@testable import NKLCB

final class NKLCBTests: XCTestCase {
    
    // MARK: - 디코딩 Test
    
    func test_정의되지_않은_회사코드가_들어오면_unknown으로_디코딩된다() throws {
        // Given: 존재하지 않는 회사 코드 "APPLE"이 포함된 JSON
        let json = """
        [
            {
                "id": 1234567890,
                "companyCd": "APPLE",
                "annoId": 100001,
                "classCdNm": "R&D",
                "empTypeCdNm": "정규",
                "annoSubject": "iOS Developer",
                "subJobCdNm": "iOS",
                "sysCompanyCdNm": "애플코리아",
                "jobDetailLink": "https://jobs.apple.com",
                "workplace": "서울",
                "startDate": null,
                "endDate": null
            }
        ]
        """.data(using: .utf8)!

        // When: 디코딩 시도
        let dto = try JSONDecoder().decode([RecruitResponseDTO].self, from: json)

        // Then: companyCode는 .unknown으로 디코딩되어야 함
        XCTAssertEqual(dto.first?.companyCode, .unknown)
    }
    
    func test_정의되지_않은_고용형태가_들어오면_unknown으로_디코딩된다() throws {
        // Given
        let json = """
        [
            {
                "id": 1234567890,
                "companyCd": "NAVER",
                "annoId": 100002,
                "classCdNm": "R&D",
                "empTypeCdNm": "계약직",
                "annoSubject": "Swift Backend Developer",
                "subJobCdNm": "Backend",
                "sysCompanyCdNm": "네이버",
                "jobDetailLink": "https://careers.naver.com",
                "workplace": "서울",
                "startDate": null,
                "endDate": null
            }
        ]
        """.data(using: .utf8)!

        // When
        let dto = try JSONDecoder().decode([RecruitResponseDTO].self, from: json)

        // Then
        XCTAssertEqual(dto.first?.jobType, .unknown)
    }
    
    func test_정의되지_않은_근무지가_들어오면_unknown으로_디코딩된다() throws {
        // Given
        let json = """
        [
            {
                "id": 1234567891,
                "companyCd": "KAKAO",
                "annoId": 100003,
                "classCdNm": "Engineering",
                "empTypeCdNm": "정규",
                "annoSubject": "AI Researcher",
                "subJobCdNm": "AI",
                "sysCompanyCdNm": "카카오브레인",
                "jobDetailLink": "https://careers.kakao.com",
                "workplace": "판교",
                "startDate": null,
                "endDate": null
            }
        ]
        """.data(using: .utf8)!

        // When
        let dto = try JSONDecoder().decode([RecruitResponseDTO].self, from: json)

        // Then
        XCTAssertEqual(dto.first?.workplace, .unknown)
    }
    
    func test_야놀자_공고_JSON_디코딩이_정상적으로_동작한다() throws {
            // Given
            let json = """
            [
                {
                    "id": -8164975947347613201,
                    "companyCd": "YANOLJA",
                    "annoId": 155360,
                    "classCdNm": "R&D",
                    "empTypeCdNm": "정규",
                    "annoSubject": "Group Security Analyst",
                    "subJobCdNm": "R&D",
                    "sysCompanyCdNm": "야놀자",
                    "jobDetailLink": "https://careers.yanolja.co/o/155360",
                    "workplace": "서울",
                    "startDate": null,
                    "endDate": null
                }
            ]
            """.data(using: .utf8)!

            // When
            let decoder = JSONDecoder()
            let dto = try decoder.decode([RecruitResponseDTO].self, from: json)

            // Then
            XCTAssertEqual(dto.count, 1)
            XCTAssertEqual(dto.first?.companyCode, .yanolja)
            XCTAssertEqual(dto.first?.jobType, .정규)
            XCTAssertEqual(dto.first?.workplace, .서울)
            XCTAssertEqual(dto.first?.title, "Group Security Analyst")
        }
    
    // MARK: - 날짜 문자열 파싱 테스트

    func test_날짜_문자열_yyyyMMddHHmmss_형태가_정상적으로_파싱된다() throws {
        // Given
        let dateString = "2025-05-12 18:00:00"
        
        // When
        guard let date = CachedDateFormatter.date(dateString, format: "yyyy-MM-dd HH:mm:ss") else {
            return XCTFail("date is nil")
        }
        
        // Then
        guard let timeZone = TimeZone(identifier: "Asia/Seoul") else { return XCTFail("timezone not found") }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        XCTAssertEqual(calendar.component(.year, from: date), 2025)
        XCTAssertEqual(calendar.component(.month, from: date), 5)
        XCTAssertEqual(calendar.component(.day, from: date), 12)
        XCTAssertEqual(calendar.component(.hour, from: date), 18)
        XCTAssertEqual(calendar.component(.minute, from: date), 0)
        XCTAssertEqual(calendar.component(.second, from: date), 0)
    }
    
    func test_날짜_문자열_yyyyMMdd_형태가_정상적으로_파싱된다() throws {
        // Given
        let dateString = "2025-05-12"
        
        // When
        guard let date = CachedDateFormatter.date(dateString, format: "yyyy-MM-dd") else {
            return XCTFail("date is nil")
        }
        
        // Then
        guard let timeZone = TimeZone(identifier: "Asia/Seoul") else { return XCTFail("timezone not found") }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        XCTAssertEqual(calendar.component(.year, from: date), 2025)
        XCTAssertEqual(calendar.component(.month, from: date), 5)
        XCTAssertEqual(calendar.component(.day, from: date), 12)
    }
    
}
