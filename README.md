# O2 Slovakia Scratch Card App

iOS application for managing scratch cards - scratch to reveal codes and activate them through the O2 API.

## Requirements

- **iOS**: 16.0+
- **Xcode**: 15.0+
- **Swift**: 5.9+

## Features

### Three-State Scratch Card System
1. **Unscratched** - Initial state
2. **Scratched** - Code revealed after 2-second operation
3. **Activated** - Card activated via O2 API

### Core Functionality
- ✅ **Scratch Operation**: 2-second async operation with UUID generation
- ✅ **Cancellation Support**: Scratch operation cancels when user navigates away
- ✅ **Non-Cancellable Activation**: Activation continues even if user leaves the screen
- ✅ **API Integration**: Validates activation through O2 version API
- ✅ **Error Handling**: Comprehensive error states and user feedback

## Architecture

### Clean Architecture Layers

```
├── Models
│   ├── ScratchCard.swift          # Data model
│   └── ScratchCardState.swift     # State enum
├── Services
│   ├── ScratchService.swift       # Scratching logic
│   └── ActivationService.swift    # API integration
├── ViewModels
│   ├── MainViewModel.swift        # Main screen state
│   ├── ScratchViewModel.swift     # Scratch screen logic
│   └── ActivationViewModel.swift  # Activation logic
├── Views
│   ├── MainView.swift            # Main screen UI
│   ├── ScratchView.swift         # Scratch screen UI
│   └── ActivationView.swift      # Activation screen UI
└── DI
    └── AppContainer.swift        # Dependency injection
```

### Key Design Patterns
- **MVVM**: Clear separation between UI and business logic
- **Protocol-Oriented**: All services use protocols for testability
- **Dependency Injection**: AppContainer manages dependencies
- **Async/Await**: Modern Swift concurrency
- **Task Cancellation**: Proper handling of long-running operations

## API Integration

**Endpoint**: `https://api.o2.sk/version`
- **Method**: GET
- **Parameter**: `code` (the revealed scratch code)
- **Success Criteria**: Response JSON contains `"ios"` value > 6.1

Example response:
```json
{
  "ios": "6.24"
}
```

## State Management

```swift
enum ScratchCardState {
    case unscratched
    case scratching
    case scratched(code: String)
    case activating(code: String)
    case activated(code: String)
    case error(String)
}
```

## Running Tests

```bash
# Run all tests
Command + U

# Run specific test suite
xcodebuild test -scheme ScratchCard -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Test Coverage
- ✅ Service layer unit tests
- ✅ ViewModel unit tests
- ✅ Model tests
- ✅ Mock implementations for testing
- ✅ Async operation testing

## Building & Running

1. Open `ScratchCard.xcodeproj` in Xcode
2. Select target device/simulator
3. Press `Command + R` to build and run

## Implementation Notes

### Scratch Operation
- Takes exactly 2 seconds (simulated heavy operation)
- Generates random UUID as the code
- **Cancels** if user navigates away before completion
- Uses `Task` with cancellation checking

### Activation Operation
- Calls O2 API with revealed code
- **Does NOT cancel** when user navigates away
- Uses `Task.detached` to ensure completion
- Shows error modal if activation fails (iOS version ≤ 6.1)

### Error Handling
- Network errors are caught and displayed
- Invalid API responses show appropriate errors
- Version check failures display specific error messages

## Dependencies

No external dependencies - uses only Swift standard library and SwiftUI.

## Project Structure Decisions

### Why Protocol-Oriented?
- Easy to mock for testing
- Flexible for future changes
- Clear contracts between components

### Why MVVM?
- Natural fit for SwiftUI
- Clear separation of concerns
- Testable business logic

### Why AppContainer?
- Centralized dependency management
- Easy to swap implementations
- Supports testing with mocks

## License

This is a coding assignment for O2 Slovakia.

## Author

Marek Hajdučák
Created: November 3, 2025
