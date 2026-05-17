import SwiftUI

struct GameDetailView: View {
    var route: String
    
    var body: some View {
        Group {
            switch route {
            case "zen":
                ZenTapView()
            default:
                placeholderView
            }
        }
        .navigationTitle(title)
    }
    
    private var placeholderView: some View {
        VStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(tintColor)
            Text(title)
                .font(.largeTitle.bold())
            Text("A premium experience is on the way.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GradientBackground())
    }
    
    private var title: String {
        switch route {
        case "zen": return "Zen Tap"
        case "orbit": return "Orbit"
        case "colorflow": return "Color Flow"
        default: return "MindPause"
        }
    }
    
    private var iconName: String {
        switch route {
        case "zen": return "hands.sparkles.fill"
        case "orbit": return "circle.dotted.and.circle"
        case "colorflow": return "paintbrush.pointed.fill"
        default: return "star"
        }
    }
    
    private var tintColor: Color {
        switch route {
        case "zen": return .blue
        case "orbit": return .purple
        case "colorflow": return .mint
        default: return .primary
        }
    }
}

#Preview {
    NavigationStack {
        GameDetailView(route: "zen")
    }
}
