import Foundation

final class RecruitModelStub: RecruitModelType, ObservableObject {
    @Published private(set) var recruits: [Recruit] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var toastMessage: String?
    
    init() {
        Task { await fetchRecruits(by: .all) }
    }
    
    func fetchRecruits(by company: CompanyFilter) async {
        isLoading = true; defer { isLoading = false }
        try? await Task.sleep(for: .milliseconds(2000))
        guard let data = try? JSONDecoder().decode([Recruit].self, from: dummyData) else { return }
        recruits = data
    }
    
    func filter(by company: CompanyFilter) -> [Recruit] {
        if company == .all {
            return recruits
        }
        return recruits.filter { $0.companyCode == company.companyCode }
    }
}
