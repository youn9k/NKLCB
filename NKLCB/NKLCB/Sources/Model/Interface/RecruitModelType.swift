import Foundation

protocol RecruitModelType: ObservableObject {
    var recruits: [RecruitEntity] { get }
    
    func fetchRecruits(by company: CompanyFilter) async
    func filter(with filter: RecruitFilter) -> [RecruitEntity]
}
