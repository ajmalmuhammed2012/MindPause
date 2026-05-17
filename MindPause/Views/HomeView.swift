//
//  HomeView.swift
//  MindPause
//
//  Created by Ajmal Muhammed on 17/05/26.
//

import SwiftUI

struct HomeView: View {
    @State private var selection: Int = 0
    @State private var appearanceMode: AppearanceMode = .dark
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationStack {
                HomeContent()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            NavigationStack {
                Text("Progress coming soon")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(GradientBackground())
                    .navigationTitle("Progress")
            }
            .tabItem {
                Image(systemName: "chart.bar.fill")
                Text("Progress")
            }
            .tag(1)
            
            NavigationStack {
                SettingsView(appearanceMode: $appearanceMode)
                    .navigationTitle("Settings")
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text("Settings")
            }
            .tag(2)
        }
        .tint(.accentColor)
        .preferredColorScheme(appearanceMode.colorScheme)
    }
}

private enum AppearanceMode: String, CaseIterable, Identifiable {
    case light = "Light"
    case dark = "Dark"
    
    var id: String { rawValue }
    
    var colorScheme: ColorScheme {
        switch self {
        case .light: return .light
        case .dark: return .dark
        }
    }
}

private struct HomeContent: View {
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                Header()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Games")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 4)
                    
                    LazyVStack(spacing: 16) {
                        NavigationLink(value: "zen") {
                            GameCardView(
                                title: "Zen Tap",
                                subtitle: "Find your rhythm",
                                icon: "hands.sparkles.fill",
                                gradient: .blue
                            )
                        }
                        .buttonStyle(.plain)
                        
                        NavigationLink(value: "orbit") {
                            GameCardView(
                                title: "Orbit",
                                subtitle: "Keep the balance",
                                icon: "circle.dotted.and.circle",
                                gradient: .purple
                            )
                        }
                        .buttonStyle(.plain)
                        
                        NavigationLink(value: "colorflow") {
                            GameCardView(
                                title: "Color Flow",
                                subtitle: "Match the hues",
                                icon: "paintbrush.pointed.fill",
                                gradient: .mint
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .background(GradientBackground())
        .navigationDestination(for: String.self) { route in
            GameDetailView(route: route)
        }
    }
}

private struct SettingsView: View {
    @Binding var appearanceMode: AppearanceMode
    
    var body: some View {
        Form {
            Section("Appearance") {
                Picker("Mode", selection: $appearanceMode) {
                    ForEach(AppearanceMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .scrollContentBackground(.hidden)
        .background(GradientBackground())
    }
}

private struct Header: View {
    @State private var appear = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("MindPause")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 8)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: appear)
            
            Text("Take a mindful break")
                .font(.callout.weight(.medium))
                .foregroundStyle(.secondary)
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 8)
                .animation(.easeOut(duration: 0.6), value: appear)
        }
        .onAppear {
            guard !appear else { return }
            appear = true
        }
    }
}

struct GradientBackground: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var colors: [Color] {
        switch colorScheme {
        case .light:
            return [
                Color(red: 0.96, green: 0.98, blue: 1.0),
                Color(red: 0.90, green: 0.95, blue: 0.98),
                Color(red: 0.86, green: 0.92, blue: 0.95)
            ]
        case .dark:
            return [
                Color.black,
                Color(red: 0.06, green: 0.07, blue: 0.10),
                Color(red: 0.08, green: 0.10, blue: 0.16)
            ]
        @unknown default:
            return [Color(.systemBackground)]
        }
    }
}

#Preview {
    HomeView()
}
