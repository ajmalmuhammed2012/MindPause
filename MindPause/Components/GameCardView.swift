import SwiftUI

struct GameCardView: View {
    var title: String
    var subtitle: String
    var icon: String
    var gradient: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            gradient.opacity(0.6),
                            gradient.opacity(0.3),
                            Color(.sRGB, white: 0.02, opacity: 0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(.white.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: gradient.opacity(0.4), radius: 20, x: 0, y: 10)
            
            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    gradient.opacity(0.7),
                                    gradient.opacity(0.4)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 54, height: 54)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.white.opacity(0.18), lineWidth: 1)
                        )
                        .shadow(color: gradient.opacity(0.5), radius: 14, x: 0, y: 7)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 1)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.3), radius: 1.5, x: 0, y: 1)
                    Text(subtitle)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.75))
                }
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(.trailing, 4)
            }
            .padding(20)
        }
        .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [
                Color(.sRGB, white: 0.05, opacity: 1),
                Color(.sRGB, white: 0.08, opacity: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        VStack(spacing: 20) {
            GameCardView(title: "Focus Flow", subtitle: "Sharpen attention", icon: "scope", gradient: .blue)
            GameCardView(title: "Memory Match", subtitle: "Train recall", icon: "brain.head.profile", gradient: .purple)
            GameCardView(title: "Calm Breaths", subtitle: "Relax & reset", icon: "wind", gradient: .mint)
        }
        .padding()
    }
}
