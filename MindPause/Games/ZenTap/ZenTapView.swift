import SwiftUI

struct ZenTapView: View {
    private enum Constants {
        static let cycleDuration: TimeInterval = 2.4
        static let targetProgress = 0.72
        static let timingWindow = 0.11
        static let minCircleSize: CGFloat = 92
        static let maxCircleSize: CGFloat = 280
    }
    
    @State private var score: Int = 0
    @State private var roundStart = Date()
    @State private var feedbackScale: CGFloat = 0.8
    @State private var feedbackOpacity: Double = 0
    @State private var hapticTrigger: Int = 0
    @State private var message = "Tap when the circle meets the ring"
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let progress = progress(at: timeline.date)
            let circleSize = circleSize(for: progress)
            let timingAccuracy = accuracy(for: progress)
            
            VStack(spacing: 28) {
                header
                
                Spacer(minLength: 12)
                
                tapArea(circleSize: circleSize, timingAccuracy: timingAccuracy)
                    .onTapGesture {
                        handleTap(progress: progress)
                    }
                    .accessibilityLabel("Zen Tap target")
                    .accessibilityHint("Tap when the expanding circle reaches the outer ring")
                
                Spacer(minLength: 12)
                
                Text(message)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 24)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(zenBackground)
            .sensoryFeedback(.impact(weight: .light, intensity: 0.45), trigger: hapticTrigger)
        }
    }
    
    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Zen Tap")
                    .font(.largeTitle.bold())
                Text("Breathe, watch, tap")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Score")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(score)")
                    .font(.title.bold())
                    .contentTransition(.numericText())
            }
            .accessibilityElement(children: .combine)
        }
    }
    
    private func tapArea(circleSize: CGFloat, timingAccuracy: Double) -> some View {
        ZStack {
            Circle()
                .stroke(.primary.opacity(0.12), lineWidth: 2)
                .frame(width: Constants.maxCircleSize, height: Constants.maxCircleSize)
            
            Circle()
                .stroke(targetRingColor(for: timingAccuracy), lineWidth: 3)
                .frame(width: Constants.maxCircleSize * 0.72, height: Constants.maxCircleSize * 0.72)
                .shadow(color: targetRingColor(for: timingAccuracy).opacity(0.28), radius: 14)
            
            Circle()
                .fill(circleGradient)
                .frame(width: circleSize, height: circleSize)
                .shadow(color: Color.blue.opacity(0.24), radius: 24, x: 0, y: 12)
            
            Circle()
                .stroke(Color.accentColor.opacity(feedbackOpacity), lineWidth: 5)
                .frame(width: Constants.maxCircleSize * feedbackScale, height: Constants.maxCircleSize * feedbackScale)
            
            Image(systemName: "hand.tap.fill")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.white.opacity(0.92))
                .shadow(color: .black.opacity(0.22), radius: 4, x: 0, y: 2)
        }
        .frame(width: Constants.maxCircleSize, height: Constants.maxCircleSize)
        .contentShape(Circle())
    }
    
    private var zenBackground: some View {
        LinearGradient(
            colors: [
                Color(.systemBackground),
                Color.accentColor.opacity(0.10),
                Color.blue.opacity(0.08)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var circleGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.blue.opacity(0.82),
                Color.mint.opacity(0.70)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private func progress(at date: Date) -> Double {
        let elapsed = date.timeIntervalSince(roundStart)
        return elapsed.truncatingRemainder(dividingBy: Constants.cycleDuration) / Constants.cycleDuration
    }
    
    private func circleSize(for progress: Double) -> CGFloat {
        Constants.minCircleSize + (Constants.maxCircleSize - Constants.minCircleSize) * progress
    }
    
    private func accuracy(for progress: Double) -> Double {
        let distance = abs(progress - Constants.targetProgress)
        return max(0, 1 - distance / Constants.timingWindow)
    }
    
    private func targetRingColor(for accuracy: Double) -> Color {
        accuracy > 0 ? .mint.opacity(0.45 + accuracy * 0.45) : .primary.opacity(0.18)
    }
    
    private func handleTap(progress: Double) {
        let isOnBeat = accuracy(for: progress) > 0
        
        if isOnBeat {
            score += 1
            message = "Nice timing"
        } else {
            message = "Let it expand a little more"
        }
        
        hapticTrigger += 1
        roundStart = Date()
        
        withAnimation(.spring(response: 0.32, dampingFraction: 0.72)) {
            feedbackScale = isOnBeat ? 0.82 : 0.58
            feedbackOpacity = isOnBeat ? 0.9 : 0.36
        }
        
        withAnimation(.easeOut(duration: 0.45).delay(0.08)) {
            feedbackOpacity = 0
        }
    }
}

#Preview {
    NavigationStack {
        ZenTapView()
    }
    .preferredColorScheme(.dark)
}
