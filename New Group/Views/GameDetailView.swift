import SwiftUI

struct GameDetailView: View {
    var route: String
    
    var body: some View {
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
        .navigationTitle(title)
    }
    
    private var title: String {
        switch route {
        case "focus": return "Focus Flow"
        case "memory": return "Memory Match"
        case "calm": return "Calm Breaths"
        default: return "MindPause"
        }
    }
    
    private var iconName: String {
        switch route {
        case "focus": return "scope"
        case "memory": return "brain.head.profile"
        case "calm": return "wind"
        default: return "star"
        }
    }
    
    private var tintColor: Color {
        switch route {
        case "focus": return .blue
        case "memory": return .purple
        case "calm": return .mint
        default: return .white
        }
    }
}

#Preview {
    NavigationStack {
        GameDetailView(route: "focus")
    }
}
