import Foundation

@MainActor
final class RecruitModel: RecruitModelType, ObservableObject {
    @Published private(set) var recruits: [Recruit] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var toastMessage: String?
    
    init() {
        Task { await fetchRecruits(by: .all) }
    }
    
    func fetchRecruits(by company: CompanyFilter) async {
        isLoading = true; defer { isLoading = false }
        let result = await NetworkService.request(RecruitAPI.fetchRecruits(company: company))
        switch result {
        case .success(let data):
            recruits = data
        case .failure(let error):
            toastMessage = error.localizedDescription
        }
    }
    
    func filter(by company: CompanyFilter) -> [Recruit] {
        if company == .all {
            return recruits
        }
        return recruits.filter { $0.companyCode == company.companyCode }
    }
}
