import Foundation

final class RecruitModelStub: RecruitModelType, ObservableObject {
    @Published private(set) var recruits: [RecruitEntity] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var toastMessage: String?
    
    init() {
        Task { await fetchRecruits(by: .all) }
    }
    
    func fetchRecruits(by company: CompanyFilter) async {
        isLoading = true; defer { isLoading = false }
        try? await Task.sleep(for: .milliseconds(200))
        guard let data = try? JSONDecoder().decode([RecruitResponseDTO].self, from: dummyData) else { return }
        recruits = RecruitMapper.map(dto: data)
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
