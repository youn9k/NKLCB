import Foundation

protocol RecruitModelType: ObservableObject {
    var recruits: [Recruit] { get }
    
    func fetchRecruits(by company: CompanyFilter) async
    func filter(by company: CompanyFilter) -> [Recruit]
}
