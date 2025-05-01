import XCTest
@testable import NKLCB

final class NKLCBTests: XCTestCase {
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
        let postings = try JSONDecoder().decode([Recruit].self, from: json)

        // Then: companyCode는 .unknown으로 디코딩되어야 함
        XCTAssertEqual(postings.first?.companyCode, .unknown)
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
                "empTypeCdNm": "계약직", // 정의되지 않은 값
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
        let postings = try JSONDecoder().decode([Recruit].self, from: json)

        // Then
        XCTAssertEqual(postings.first?.jobType, .unknown)
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
                "workplace": "판교", // 정의되지 않은 값
                "startDate": null,
                "endDate": null
            }
        ]
        """.data(using: .utf8)!

        // When
        let postings = try JSONDecoder().decode([Recruit].self, from: json)

        // Then
        XCTAssertEqual(postings.first?.workplace, .unknown)
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
            let postings = try decoder.decode([Recruit].self, from: json)

            // Then
            XCTAssertEqual(postings.count, 1)
            XCTAssertEqual(postings.first?.companyCode, .yanolja)
            XCTAssertEqual(postings.first?.jobType, .정규)
            XCTAssertEqual(postings.first?.workplace, .서울)
            XCTAssertEqual(postings.first?.title, "Group Security Analyst")
        }
}
