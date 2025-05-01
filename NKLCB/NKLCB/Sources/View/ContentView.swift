import SwiftUI
import SafariServices

struct ContentView: View {
    
    // MARK: Model
    #if DEBUG
    @StateObject private var recruitModel = RecruitModelStub()
    #else
    @StateObject private var recruitModel = RecruitModel()
    #endif
    
    // MARK: State
    private var visibleRecruits: [RecruitEntity] {
        recruitModel.filter(with: filter)
    }
    
    private var visiblePositions: [String] {
        return Array(Set(
            recruitModel.recruits
                .filter({
                    filter.company == .all || $0.companyCode == filter.company.companyCode
                })
                .compactMap(\.positionType)
        ))
        .sorted()
    }
    
    @State private var filter = RecruitFilter()
    @State private var selectedURL: URL?
    @State private var isPositionSheetPresented = false
    
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
                        VStack(spacing: 15) {
                            filterView
                            positionFilterView
                        }
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
            .sheet(isPresented: $isPositionSheetPresented) {
                PositionFilterBottomSheetView(
                    isPresented: $isPositionSheetPresented,
                    selectedPosition: $filter.position,
                    positions: visiblePositions
                )
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
    
    var positionFilterView: some View {
        Button {
            isPositionSheetPresented = true
        } label: {
            HStack {
                Image(.airplane)
                Text(filter.position ?? "해당 공고에서 \(visiblePositions.count)개의 직무를 찾았어요.")
                Spacer()
                Image(.arrowBottom)
            }
            .nkFont(.t4(.medium))
            .foregroundStyle(.gray600)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .stroke(Color.gray200, lineWidth: 1)
            }
        }
        .padding(.horizontal, 20)
    }
    
    var RecruitGridView: some View {
        ScrollView {
            LazyVGrid(columns: recruitGridColumns, spacing: 10) {
                Group {
                    if recruitModel.isLoading {
                        ForEach((0..<4)) { _ in
                            RecruitCardSkeletonView()
                        }
                    } else {
                        ForEach(visibleRecruits, id: \.id) { recruit in
                            RecruitCardView(
                                companyName: recruit.detailedCompanyName,
                                title: recruit.title,
                                period: recruit.recruitPeriod,
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
