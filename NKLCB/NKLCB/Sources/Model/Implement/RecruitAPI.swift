import Alamofire

enum RecruitAPI: API {
    case fetchRecruits(company: CompanyFilter)

    var baseURL: String {
        config(key: "BASE_URL") ?? ""
    }

    var path: String {
        switch self {
        case .fetchRecruits: config(key: "RECRUIT_LIST") ?? ""
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchRecruits: .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .fetchRecruits(let company):
            let value = company.queryParameter
            return ["company": value]
        }
    }
}
