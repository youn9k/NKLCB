import SwiftUI

struct PositionFilterBottomSheetView: View {
    @Environment(\.colorScheme) var colorSchme
    
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
                        positionCell(title: position, isSelected: isSelected)
                    }
                }
            }
            .padding()
        }
    }
    
    func positionCell(title: String, isSelected: Bool) -> some View {
        HStack {
            if isSelected { Image(systemName: "checkmark") }
            Text(title)
        }
        .nkFont(.t4(isSelected ? .bold : .medium))
        .foregroundStyle(positionCellColor(isSelected))
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .frame(maxWidth: .infinity, alignment: .leading)
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

extension PositionFilterBottomSheetView {
    private func positionCellColor(_ isSelected: Bool) -> Color {
        if colorSchme == .dark {
            isSelected ? Color.white : Color.gray300
        } else {
            isSelected ? Color.gray900 : Color.gray700
        }
    }
}

#Preview {
    ContentView()
}
