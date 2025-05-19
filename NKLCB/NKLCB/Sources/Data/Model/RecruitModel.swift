import Foundation

@MainActor
final class RecruitModel: RecruitModelType, ObservableObject {
    @Published private(set) var recruits: [RecruitEntity] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var toastMessage: String?
    
    init() {
        Task { await fetchRecruits(by: .all) }
    }
    
    func fetchRecruits(by company: CompanyFilter) async {
        isLoading = true; defer { isLoading = false }
        let result: Result<[RecruitResponseDTO], Error> = await NetworkService.shared.request(RecruitAPI.fetchRecruits(company: company))
        switch result {
        case .success(let data):
            let fetched = RecruitMapper.map(dto: data)
            recruits = fetched
        case .failure(let error):
            toastMessage = error.localizedDescription
        }
    }
    
    func filter(with filter: RecruitFilter) -> [RecruitEntity] {
        return recruits.filter {
            let matchedCompany = matchedCompany($0, filter)
            let matchedPosition = matchedPosition($0, filter)
            return matchedCompany && matchedPosition
        }
    }
    
    private func matchedCompany(_ recruit: RecruitEntity, _ filter: RecruitFilter) -> Bool {
        return filter.company == .all || recruit.companyCode == filter.company.companyCode
    }
    
    private func matchedPosition(_ recruit: RecruitEntity, _ filter: RecruitFilter) -> Bool {
        return filter.position == nil || recruit.positionType == filter.position
    }
}
