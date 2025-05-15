import SwiftUI

struct FilterCapsuleView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let title: String
    let color: Color
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .nkFont(.t4(isSelected ? .bold : .medium))
            .lineLimit(1)
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
                    .fill(color)
            } else {
                Capsule()
                    .fill(Color.white)
                    .stroke(Color.gray200, lineWidth: 1)
            }
        }
        .animation(
            .easeInOut(duration: 0.2),
            value: isSelected
        )
    }
}

#Preview {
    ContentView()
}
