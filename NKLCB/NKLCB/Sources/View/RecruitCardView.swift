import SwiftUI

struct RecruitCardView: View {
    let companyName: String
    let title: String
    let startDate: String?
    let endDate: String?
    let position: String
    let jobType: String
    let detailPageURL: String
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.gray50
            VStack(alignment: .leading, spacing: 10) {
                companyView
                titleView
                periodView
                descriptionView
                Spacer()

            }
            .padding()
            
        }
    }
    
    var companyView: some View {
        HStack {
            Text(companyName)
                .nkFont(.t5(.medium))
                .lineLimit(1)
                .foregroundStyle(.gray500)
            Spacer()
        }
    }
    
    var titleView: some View {
        Text(title)
            .nkFont(.t4(.bold))
            .foregroundStyle(.gray900)
    }
    
    var periodView: some View {
        HStack {
            Image(.calendar)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
            Text(period(from: startDate, to: endDate))
                .nkFont(.t5(.medium))
                .foregroundStyle(.gray700)
        }
    }
    
    var descriptionView: some View {
            Text(description(position: position, jobType: jobType))
                .nkFont(.t5(.medium))
                .foregroundStyle(.gray700)
    }
    
    func period(from: String?, to: String?) -> String {
        return "~ 2025-12-31"
    }
    
    func description(position: String, jobType: String) -> String {
        let jobType = jobType == "정규" || jobType == "비정규" ?
        "\(jobType)직" : jobType
        
        return "\(position) 의 \(jobType) 으로 뽑고 있어요."
    }
}

struct RecruitCardSkeletonView: View {
    var body: some View {
        ZStack(alignment: .center) {
            Color.gray50
            VStack(alignment: .leading, spacing: 10) {
                companyPlaceHolderView
                titlePlaceHolderView
                Spacer()
            }
            .padding()
        }
    }
    
    var rectangleView: some View {
        Rectangle()
            .foregroundStyle(.gray200)
    }
    
    var companyPlaceHolderView: some View {
        HStack {
            rectangleView
                .frame(width: 60, height: 20)
            Spacer()
        }
    }
    
    var titlePlaceHolderView: some View {
        VStack(spacing: 5) {
            rectangleView
                .frame(height: 20)
            rectangleView
                .frame(height: 20)
        }
    }
}
