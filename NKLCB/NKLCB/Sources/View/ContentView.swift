import SwiftUI
import SafariServices

struct ContentView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let data = try! JSONDecoder().decode([JobPosting].self, from: dummyData)
    
    let tags = ["전체", "네이버", "카카오", "라인", "쿠팡", "배민", "당근", "토스", "야놀자"]
    @State var selectedTag: String = "전체"
    @State private var selectedURL: URL?
    
    var body: some View {
        VStack {
            logoView
                .frame(height: 60)
                .padding()
            ScrollView(.horizontal, showsIndicators: false) {
                filterView
            }
            .padding(.horizontal, 20)
            ScrollView {
                RecruitGridView
            }
        }
        .sheet(item: $selectedURL) { url in
            FullScreenWebView(url: url)
        }
    }
    
    var logoView: some View {
        Image(.nklcbLogo)
            .resizable()
            .scaledToFit()
    }
    
    var filterView: some View {
        HStack {
            ForEach(tags, id: \.self) { tag in
                TagCapsuleView(
                    tag: tag,
                    isSelected: tag == selectedTag
                )
                .onTapGesture {
                    selectedTag = tag
                }
            }
        }
    }
    
    var RecruitGridView: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(data, id: \.postingID) { job in
                RecruitCardView(
                    companyName: job.detailedCompanyName,
                    title: job.title,
                    startDate: job.startDate,
                    endDate: job.endDate,
                    position: job.positionType,
                    jobType: job.jobType.rawValue,
                    detailPageURL: job.detailPageURL
                )
                .frame(maxWidth: .infinity)
                .cornerRadius(12)
                .onTapGesture {
                    guard let url = URL(string: job.detailPageURL) else { return }
                    selectedURL = url
                }
            }
        }
        .padding(20)
    }
}

struct TagCapsuleView: View {
    let tag: String
    let isSelected: Bool
    
    var body: some View {
        Text(tag)
            .foregroundStyle(isSelected ? .white : .gray900)
            .frame(minWidth: 40, minHeight: 40)
            .padding(.horizontal, 15)
            .background {
                capsuleView
            }
    }
    
    var capsuleView: some View {
        Group {
            if isSelected {
                Capsule()
                    .fill(Color.gray900)
            } else {
                Capsule()
                    .stroke(Color.gray200, lineWidth: 1)
            }
        }
        .animation(
            .easeInOut(duration: 0.2),
            value: isSelected
        )
    }
}

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
                //periodView
                descriptionView
                Spacer()

            }
            .padding()
            
        }
    }
    
    var companyView: some View {
        HStack {
            Text(companyName)
                .lineLimit(1)
                .foregroundStyle(.gray500)
            Spacer()
        }
    }
    
    var titleView: some View {
        Text(title)
            .foregroundStyle(.gray900)
            .bold()
    }
    
    var periodView: some View {
        Text(period(from: startDate, to: endDate))
            .foregroundStyle(.gray700)
    }
    
    var descriptionView: some View {
        Text(description(position: position, jobType: jobType))
            .foregroundStyle(.gray700)
    }
    
    func period(from: String?, to: String?) -> String {
        return "2025-04-30 09:00 ~ 2025-12-31 14:59"
    }
    
    func description(position: String, jobType: String) -> String {
        let jobType = jobType == "정규" || jobType == "비정규" ?
        "\(jobType)직" : jobType
        
        return "\(position) 의 \(jobType) 으로 뽑고 있어요."
    }
}

struct FullScreenWebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .popover
        return safariVC
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}


extension URL: @retroactive Identifiable {
    public var id: String {
        self.absoluteString
    }
}

#Preview {
    ContentView()
}
