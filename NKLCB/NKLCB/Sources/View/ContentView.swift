import SwiftUI
import SafariServices

struct ContentView: View {
    
    // MARK: Model
    @StateObject private var recruitModel = RecruitModelStub()
    
    // MARK: State
    private var visibleRecruits: [Recruit] {
        recruitModel.filter(with: filter)
    }
    
    private var visiblePositions: [String] {
        return visibleRecruits.compactMap(\.positionType)
    }

    @State private var filter = RecruitFilter()
    @State private var selectedURL: URL?
    
    private let recruitGridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    logoView
                        .id("top")
                    
                    Section {
                        RecruitGridView
                    } header: {
                        filterView
                    }
                }
            }
            .onChange(of: filter) {
                withAnimation {
                    proxy.scrollTo("top", anchor: .top)
                }
            }
            .sheet(item: $selectedURL) { url in
                WebView(url: url)
            }
        }
    }
    
    var logoView: some View {
        Image(.nklcbLogo)
            .resizable()
            .scaledToFit()
            .frame(height: 60)
            .padding(.horizontal, 60)
            .padding(.vertical, 40)
    }
    
    var filterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(CompanyFilter.allCases, id: \.self) { company in
                    FilterCapsuleView(
                        title: company.rawValue,
                        color: company.companyColor,
                        isSelected: company == filter.company
                    )
                    .onTapGesture {
                        filter.company = company
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    var RecruitGridView: some View {
        ScrollView {
            LazyVGrid(columns: recruitGridColumns, spacing: 10) {
                Group{
                    if recruitModel.isLoading {
                        ForEach((0..<4)) { _ in
                            RecruitCardSkeletonView()
                        }
                    } else {
                        ForEach(visibleRecruits, id: \.id) { recruit in
                            RecruitCardView(
                                companyName: recruit.detailedCompanyName,
                                title: recruit.title,
                                startDate: recruit.startDate,
                                endDate: recruit.endDate,
                                position: recruit.positionType,
                                jobType: recruit.jobType.rawValue,
                                detailPageURL: recruit.detailPageURL
                            )
                            .onTapGesture {
                                guard let url = URL(string: recruit.detailPageURL) else { return }
                                selectedURL = url
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .cornerRadius(12)
            }
            .padding(20)
        }
    }
}

extension URL: @retroactive Identifiable {
    public var id: String {
        self.absoluteString
    }
}

#Preview {
    ContentView()
}
