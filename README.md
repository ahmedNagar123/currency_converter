# Currency Converter App

A Flutter application for currency conversion with support for viewing supported currencies, real-time conversion, and historical exchange rates.

## Features

1. **List of Supported Currencies**: Display all supported currencies with their country flags
2. **Currency Converter**: Convert between any two currencies with real-time exchange rates
3. **Historical Data**: View historical exchange rates for the last 7 days for any two currencies
4. **Offline Support**: Currencies are cached locally after the first API request

## Build Instructions

### Prerequisites

- Flutter SDK (3.10.1 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (recommended IDE)

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd currency_converter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (for Hive adapters and Injectable)**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Running Tests

```bash
flutter test
```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## Architecture

### Design Pattern: Clean Architecture

This application follows **Clean Architecture** principles, which provides:

1. **Separation of Concerns**: The app is divided into three main layers:
   - **Domain Layer**: Contains business logic, entities, and use cases (independent of frameworks)
   - **Data Layer**: Handles data sources (API, local database) and repository implementations
   - **Presentation Layer**: Contains UI components and state management (BLoC)

2. **Dependency Rule**: Dependencies point inward - presentation depends on domain, data depends on domain, but domain is independent

3. **Testability**: Each layer can be tested independently with clear boundaries

4. **Maintainability**: Changes in one layer don't affect others, making the codebase easier to maintain and extend

5. **Scalability**: Easy to add new features or modify existing ones without breaking the architecture

**Why Clean Architecture?**
- Ensures business logic is independent of UI and data sources
- Makes the codebase testable and maintainable
- Follows SOLID principles
- Industry-standard approach for Flutter applications
- Easy to onboard new developers

### State Management: BLoC Pattern

The app uses **BLoC (Business Logic Component)** pattern for state management:

- **Separation of UI and Business Logic**: UI is completely decoupled from business logic
- **Testability**: BLoC logic can be tested independently
- **Predictable State Management**: Unidirectional data flow makes state changes predictable
- **Reactive Programming**: Uses streams for reactive updates
- **Integration with Clean Architecture**: BLoC fits perfectly in the presentation layer

## Image Loading Library

### Library: `cached_network_image`

**Why `cached_network_image`?**

1. **Performance**: Automatically caches images locally, reducing network requests and improving load times
2. **User Experience**: Shows placeholder while loading and error widget on failure
3. **Memory Management**: Efficiently manages image memory, preventing memory leaks
4. **Offline Support**: Displays cached images when offline
5. **Easy Integration**: Simple API that works seamlessly with Flutter widgets
6. **Flag Loading**: Perfect for loading country flags from `flagcdn.com` with caching

**Usage in the app**: Used to load and cache country flags from `https://flagcdn.com/` for each currency.

## Database

### Library: Hive

**Why Hive?**

1. **Performance**: Fast, lightweight NoSQL database written in pure Dart
2. **No Native Dependencies**: Works on all platforms without platform-specific code
3. **Type Safety**: Strong typing with code generation support
4. **Simple API**: Easy to use with minimal boilerplate
5. **Perfect for Local Caching**: Ideal for storing currency list after first API call
6. **Fast Reads/Writes**: Optimized for mobile performance
7. **No SQL Required**: Simple key-value storage perfect for our use case

**Usage in the app**: Stores the list of supported currencies locally after the first API request, allowing the app to work offline and reducing API calls.

## Dependency Injection

### Library: `get_it` + `injectable`

**Why `get_it` + `injectable`?**

1. **Type Safety**: Compile-time dependency resolution
2. **Code Generation**: `injectable` generates boilerplate code automatically
3. **Performance**: Fast dependency lookup with no runtime overhead
4. **Easy Testing**: Simple to mock dependencies for unit tests
5. **Lazy Initialization**: Dependencies are created only when needed
6. **Singleton Support**: Easy management of singleton instances

## API

The app uses the free Currency Converter API:
- **Base URL**: `https://free.currconv.com/api/v7`
- **Endpoints**:
  - `/currencies` - Get list of supported currencies
  - `/convert` - Convert between currencies
  - `/convert` (with date range) - Get historical rates

**Note**: The API is free and doesn't require an API key for basic usage.

## Project Structure

```
lib/
├── core/
│   └── di/              # Dependency injection setup
├── data/
│   ├── datasources/     # Remote and local data sources
│   ├── models/          # Data models (extend domain entities)
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Business entities
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Business logic use cases
└── presentation/
    ├── bloc/            # BLoC state management
    ├── pages/           # Screen widgets
    └── widgets/         # Reusable UI components
```

## Testing

The app includes unit tests for:
- API integration (data sources)
- Business logic (use cases)
- State management (BLoC)

Run tests with:
```bash
flutter test
```

## Dependencies

### Main Dependencies
- `flutter_bloc`: State management
- `get_it` + `injectable`: Dependency injection
- `dio`: HTTP client for API calls
- `hive` + `hive_flutter`: Local database
- `cached_network_image`: Image loading and caching
- `equatable`: Value equality
- `intl`: Internationalization and formatting

### Dev Dependencies
- `build_runner`: Code generation
- `mocktail`: Mocking for tests
- `bloc_test`: BLoC testing utilities

## License

This project is created as a technical assessment.

## Author

Ahmed Elnajar
