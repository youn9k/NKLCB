import Foundation

protocol RecruitModelType: ObservableObject {
    var recruits: [Recruit] { get }
    
    func fetchRecruits(by company: CompanyFilter) async
    func filter(with filter: RecruitFilter) -> [Recruit]
}
