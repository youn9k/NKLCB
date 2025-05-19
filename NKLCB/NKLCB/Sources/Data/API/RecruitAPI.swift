enum RecruitAPI: API {
    case fetchRecruits(company: CompanyFilter)

    var baseURL: String {
        config(key: "BASE_URL") ?? ""
    }

    var method: Method {
        switch self {
        case .fetchRecruits: .get
        }
    }

    
    var path: String {
        switch self {
        case .fetchRecruits: config(key: "RECRUIT_LIST") ?? ""
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: [String : String]? {
        switch self {
        case .fetchRecruits(let company):
            let value = company.queryParameter
            return ["company": value]
        }
    }
    
    var body: Encodable? {
        return nil
    }
}
