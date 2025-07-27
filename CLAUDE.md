# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Orbit (오르비 알람)** - A fortune-based alarm clock iOS application using RIBs architecture.

## Essential Commands

### Project Generation & Development
```bash
# Generate Xcode project
tuist generate

# Open Tuist configuration for editing
tuist edit

# Create new feature module
make Feature name=<FeatureName>                    # With example app
make Feature name=<FeatureName> noapp=true         # Without example app
```

### Build & Deployment
```bash
# Deploy to TestFlight via Fastlane
fastlane betaOrbit           # Main app
fastlane betaOnboarding      # Onboarding demo
fastlane betaShakeMission    # Shake mission demo
```

## Architecture

### RIBs Pattern
Each feature follows Uber's RIBs architecture:
- **Builder**: Creates the RIB
- **Router**: Handles navigation
- **Interactor**: Business logic
- **ViewController**: UI presentation

### Module Structure
```
Projects/
├── Feature/            # Feature modules
│   ├── <FeatureName>/
│   │   ├── Feature/Sources/
│   │   ├── Example/    # Demo app
│   │   └── Tests/
├── Core/              # Core utilities
├── Dependency/        # Dependency modules
└── App/               # Main application
```

### Key Features
- **Onboarding**: User onboarding flow
- **Main**: Main page with alarm list
- **Alarm**: Alarm creation and editing
- **AlarmMission**: Wake-up missions (tap/shake)
- **AlarmRelease**: Alarm dismissal with fortune
- **Fortune**: Fortune display
- **AlarmController**: Background alarm scheduling

### Dependencies
- **Architecture**: RIBs
- **UI**: SnapKit, Then
- **Animation**: Lottie
- **Networking**: Alamofire
- **Analytics**: Firebase, Amplitude

### Development Notes
- Main branch: `develop`
- iOS deployment target configured in `Project.Environment.deploymentTarget`
- Bundle ID: `com.yaf.orbit`
- Background modes enabled for alarm functionality