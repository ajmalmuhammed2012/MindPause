# MindPause — AI Development Rules

This document defines persistent AI development instructions for the MindPause project. All future code, refactors, and explanations must adhere to these rules unless explicitly instructed otherwise by the project owner.

## Project Vision
- Build a premium, iOS-only brain games app that promotes calmness, focus, and relaxation.
- Deliver an Apple-quality experience with smooth interactions, impeccable typography, and subtle motion.
- Encourage short, delightful sessions that reduce cognitive load and feel restorative rather than demanding.
- Prioritize approachability and clarity: the app should feel familiar and effortless from the first launch.

## Technical Rules
- SwiftUI only; avoid UIKit unless absolutely necessary (and document why if used).
- Dark mode support by default; design and test in dark appearance first.
- Lightweight performance: minimize view complexity, avoid unnecessary work in body, prefer value types.
- Smooth animations using SwiftUI’s native animation system (spring/ease), with short durations and subtle motion.
- Native Apple-style UI: leverage system components, SF Symbols, dynamic type, and semantic colors.
- Reusable components: extract repeated UI into Components/ with clear, simple APIs.
- Beginner-friendly architecture: keep layers shallow and easy to navigate; avoid overengineering.
- Offline-first: no backend for MVP; store minimal state locally as needed.
- No third-party packages unless explicitly requested.
- Accessibility: support Dynamic Type and VoiceOver labels where reasonable.

## Architecture Rules
Organize the Xcode project using these groups (and matching folders where possible):
- App: App entry point and app-wide configuration (e.g., MindPauseApp.swift).
- Views: Top-level screens and navigation shells (e.g., HomeView.swift).
- Components: Reusable UI building blocks (e.g., GameCardView.swift).
- Games: Game-specific views and logic (e.g., ZenTapView.swift, OrbitView.swift, ColorFlowView.swift).
- Models: Lightweight data models and simple domain types.
- Services: Local-only services for MVP (e.g., persistence, settings); avoid networking.
- Assets: Asset catalogs, app icons, colors.

Guidelines:
- Keep files small and focused; prefer composition over inheritance.
- Use Swift Concurrency only when needed; avoid premature async complexity.
- Use NavigationStack and TabView for navigation; keep routes simple and type-safe when practical.
- Centralize shared styles (colors, gradients, spacing) in small, discoverable helpers.

## UI/UX Style Rules
- Minimalist, calm, and premium — inspired by Apple Fitness, Journal, Health, Headspace, and Calm.
- Prefer soft gradients, rounded corners, and gentle depth (subtle shadows or materials).
- Ensure ample spacing, clear hierarchy, and large, legible titles.
- Favor motion with purpose: small spring animations for presses and transitions; avoid excessive parallax.
- Use SF Symbols for icons; ensure good contrast on dark backgrounds.
- Respect platform conventions; avoid custom controls when a system control fits.

## Gameplay Philosophy
- Sessions are short, relaxing, and satisfying.
- Games should promote focus and mindfulness rather than stress or competition.
- Clear goals, immediate feedback, and low cognitive overhead.
- Progressive difficulty can exist, but onboarding must be frictionless.

## MVP Scope
- Platforms: iOS only.
- Games included: Zen Tap, Orbit, Color Flow.
- No backend or account system; offline-first.
- Local-only persistence if needed (e.g., simple progress or streaks) using lightweight approaches.
- Basic navigation with a bottom tab bar and a premium Home view featuring the three games.

## Coding Style Rules
- Prefer small, composable SwiftUI views with clear inputs and minimal state.
- Use structs for views and models; keep view models light if/when introduced.
- Use explicit `Color` references when inference errors occur (e.g., `Color.blue`).
- Name files after their primary types (e.g., `HomeView.swift`, `GameCardView.swift`).
- Provide `#Preview` blocks for new views; keep previews simple and performant.
- Use consistent spacing and typography; prefer `.headline`, `.title`, `.largeTitle` where appropriate.
- Avoid magic numbers; introduce small constants when values repeat.
- Add concise comments only where intent isn’t obvious; favor self-documenting code.

## Planned Games
- Zen Tap — rhythmic, calming tapping interactions.
- Orbit — balancing orbits with gentle motion and focus.
- Color Flow — matching or aligning hues with smooth transitions.

## How to Place This File in Xcode
- Put `AI_RULES.md` at the root of the MindPause Xcode project (top-level alongside the app target files).
- In Xcode’s Project Navigator, you can drag the file into the project root so it’s visible to collaborators.
- This file does not need to be included in any build target.

## How to Reference in Future Prompts
- Begin prompts with: “Follow AI_RULES.md for MindPause.”
- Reference specific sections as needed (e.g., “Use the UI/UX Style Rules and Components architecture”).
- If a prompt requires exceptions (e.g., temporary UIKit usage), explicitly state the exception and rationale.

## Enforcement for Future Code Generation
- All future SwiftUI code and architectural suggestions must comply with this document by default.
- If a trade-off is necessary (performance, accessibility, or platform constraints), clearly document the decision in the response.
- Prefer minimal, focused changes that maintain the architecture and style defined here.
