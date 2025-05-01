import SwiftUI

struct PositionFilterBottomSheetView: View {
    @Binding var isPresented: Bool
    @Binding var selectedPosition: String?
    let positions: [String]
    let gridColumns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            positionListView
            clearButton
        }
        .presentationDetents([.medium, .large])
    }
    
    var positionListView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                ForEach(positions, id: \.self) { position in
                    let isSelected = selectedPosition == position
                    Button(action: {
                        selectedPosition = position
                        isPresented = false
                    }) {
                        HStack {
                            Image(systemName: isSelected ? "checkmark" : "")
                            Text(position)
                        }
                        .nkFont(.t4(isSelected ? .bold : .medium))
                        .foregroundStyle(isSelected ? Color.gray900 : Color.gray700)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
        }
    }
    
    var clearButton: some View {
        Button("선택 초기화") {
            selectedPosition = nil
            isPresented = false
        }
        .foregroundColor(.red)
        .padding()
    }
}
