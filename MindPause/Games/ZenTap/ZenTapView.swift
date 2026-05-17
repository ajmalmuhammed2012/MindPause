import SwiftUI

struct ZenTapView: View {
    private enum Constants {
        static let cycleDuration: TimeInterval = 2.4
        static let targetProgress = 0.72
        static let timingWindow = 0.11
        static let perfectWindow = 0.035
        static let feedbackSpring = Animation.spring(response: 0.46, dampingFraction: 0.86, blendDuration: 0.06)
        static let feedbackFade = Animation.easeOut(duration: 0.62).delay(0.06)
        static let minCircleSize: CGFloat = 92
        static let maxCircleSize: CGFloat = 280
        static let playAreaSize: CGFloat = 320
    }
    
    @State private var score: Int = 0
    @State private var roundStart = Date()
    @State private var feedbackScale: CGFloat = 0.8
    @State private var feedbackOpacity: Double = 0
    @State private var tapHapticTrigger: Int = 0
    @State private var successHapticTrigger: Int = 0
    @State private var message = "Tap when the circle meets the ring"
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let progress = progress(at: timeline.date)
            let circleSize = circleSize(for: progress)
            let timingAccuracy = accuracy(for: progress)
            
            VStack(spacing: 24) {
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
            .padding(.top, 28)
            .padding(.bottom, 32)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(zenBackground)
            .sensoryFeedback(.impact(weight: .light, intensity: 0.28), trigger: tapHapticTrigger)
            .sensoryFeedback(.success, trigger: successHapticTrigger)
        }
    }
    
    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Zen Tap")
                    .font(.largeTitle.bold())
                Text("Breathe, watch, tap")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Score")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                Text("\(score)")
                    .font(.title.bold())
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .animation(Constants.feedbackSpring, value: score)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .accessibilityElement(children: .combine)
        }
    }
    
    private func tapArea(circleSize: CGFloat, timingAccuracy: Double) -> some View {
        ZStack {
            Circle()
                .fill(playAreaGradient)
                .frame(width: Constants.playAreaSize, height: Constants.playAreaSize)
                .shadow(color: Color.blue.opacity(0.18), radius: 34, x: 0, y: 18)
            
            Circle()
                .stroke(.primary.opacity(0.08), lineWidth: 1)
                .frame(width: Constants.maxCircleSize, height: Constants.maxCircleSize)
            
            Circle()
                .stroke(targetRingColor(for: timingAccuracy), lineWidth: 2.5)
                .frame(width: Constants.maxCircleSize * 0.72, height: Constants.maxCircleSize * 0.72)
                .shadow(color: targetRingColor(for: timingAccuracy).opacity(0.32), radius: 18)
            
            Circle()
                .fill(circleGradient)
                .overlay(
                    Circle()
                        .stroke(.white.opacity(0.18), lineWidth: 1)
                )
                .frame(width: circleSize, height: circleSize)
                .shadow(color: Color.mint.opacity(0.20), radius: 18, x: 0, y: 8)
                .shadow(color: Color.blue.opacity(0.18), radius: 28, x: 0, y: 18)
            
            Circle()
                .stroke(Color.accentColor.opacity(feedbackOpacity), lineWidth: 3)
                .frame(width: Constants.maxCircleSize, height: Constants.maxCircleSize)
                .scaleEffect(feedbackScale)
            
            Image(systemName: "hand.tap.fill")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.white.opacity(0.9))
                .shadow(color: .black.opacity(0.24), radius: 5, x: 0, y: 2)
        }
        .frame(width: Constants.playAreaSize, height: Constants.playAreaSize)
        .contentShape(Circle())
    }
    
    private var zenBackground: some View {
        LinearGradient(
            colors: [
                Color(.systemBackground),
                Color.blue.opacity(0.09),
                Color.mint.opacity(0.07)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var playAreaGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(.secondarySystemBackground).opacity(0.72),
                Color.blue.opacity(0.10),
                Color.mint.opacity(0.08)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var circleGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.blue.opacity(0.88),
                Color.cyan.opacity(0.76),
                Color.mint.opacity(0.66)
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
        let easedProgress = progress * progress * (3 - 2 * progress)
        return Constants.minCircleSize + (Constants.maxCircleSize - Constants.minCircleSize) * easedProgress
    }
    
    private func accuracy(for progress: Double) -> Double {
        let distance = abs(progress - Constants.targetProgress)
        return max(0, 1 - distance / Constants.timingWindow)
    }
    
    private func targetRingColor(for accuracy: Double) -> Color {
        accuracy > 0 ? .mint.opacity(0.45 + accuracy * 0.45) : .primary.opacity(0.18)
    }
    
    private func handleTap(progress: Double) {
        let tapAccuracy = accuracy(for: progress)
        let isOnBeat = tapAccuracy > 0
        let isPerfectTap = abs(progress - Constants.targetProgress) <= Constants.perfectWindow
        
        if isPerfectTap {
            score += 1
            message = "Perfect"
            successHapticTrigger += 1
        } else if isOnBeat {
            score += 1
            message = "Nice timing"
        } else {
            message = "Let it expand a little more"
        }
        
        tapHapticTrigger += 1
        roundStart = Date()
        
        var resetTransaction = Transaction()
        resetTransaction.disablesAnimations = true
        withTransaction(resetTransaction) {
            feedbackScale = isOnBeat ? 0.58 : 0.46
            feedbackOpacity = isOnBeat ? 0.72 : 0.28
        }
        
        withAnimation(Constants.feedbackSpring) {
            feedbackScale = isPerfectTap ? 1.04 : isOnBeat ? 0.94 : 0.72
        }
        
        withAnimation(Constants.feedbackFade) {
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
