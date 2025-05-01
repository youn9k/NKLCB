struct RecruitFilter: Equatable {
    var company: CompanyFilter = .all
    var position: String? = nil
}
