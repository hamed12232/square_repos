# Square Repos

A Flutter application that fetches and displays public repositories of **Square** from the GitHub API. Built with **Clean Architecture**, **Feature-First** folder structure, and **flutter_bloc** (Cubit) state management.

---

## Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Architecture Deep Dive](#architecture-deep-dive)
- [Data Flow](#data-flow)
- [Error Handling](#error-handling)
- [Caching Strategy](#caching-strategy)
- [Background Sync](#background-sync)
- [Local Notifications](#local-notifications)
- [Search](#search)
- [UI Components](#ui-components)
- [Dependency Injection](#dependency-injection)
- [Testing](#testing)
- [Git Conventions](#git-conventions)

---

## Features

| Feature | Description |
|---|---|
| **Repository Listing** | Displays Square's public GitHub repositories in a paginated list |
| **Pagination** | Infinite scroll with automatic loading of the next page |
| **Offline Support** | Falls back to locally cached data when there is no internet connection |
| **Client-Side Search** | Real-time search by repository name, description, or owner username |
| **Fork Indicator** | Light green background for original repos, white for forks |
| **Long-Press Navigation** | Dialog to open repository or owner profile URL in the browser |
| **Background Sync** | Periodic background task (every 1 hour) to check for new repositories |
| **Local Notifications** | Notifies the user when new repositories are detected in background sync |
| **Skeleton Loading** | Skeleton shimmer effect while data is loading |
| **Responsive Design** | Adaptive layout using `flutter_screenutil` |

---

## Architecture

This project strictly follows **Feature-First Clean Architecture** with three layers:

```
┌─────────────────────────────────────────────┐
│              Presentation Layer             │
│   Widgets ─► Cubit ─► UseCases              │
├─────────────────────────────────────────────┤
│                Domain Layer                 │
│   Entities, Repository Interfaces, UseCases │
├─────────────────────────────────────────────┤
│                 Data Layer                  │
│   Models, Repository Impl, DataSources      │
│         (Remote / Local)                    │
└─────────────────────────────────────────────┘
```

### Dependency Rule

- **Presentation** → only talks to **Cubit**
- **Cubit** → only talks to **UseCases**
- **UseCases** → only talk to **Repository Interfaces** (domain)
- **Repository Implementation** → chooses between **Remote** or **Local** DataSource
- **DataSource** → handles API calls or local database operations

> The Presentation layer never knows about caching, networking, or data sources.

---

## Project Structure

```
lib/
│
├── main.dart                          # App entry point, WorkManager & Notifications init
│
├── app/
│   └── app.dart                       # MaterialApp.router with ScreenUtil & theme
│
├── core/
│   ├── constants/
│   │   └── api_constant.dart          # Base URL & endpoint constants
│   │
│   ├── di/
│   │   └── service_locator.dart       # GetIt dependency injection setup
│   │
│   ├── errors/
│   │   ├── exceptions.dart            # ServerException, ErrorMessageModel
│   │   └── failures.dart              # Failure classes, DioException handler
│   │
│   ├── routes/
│   │   └── app_router.dart            # GoRouter configuration (AppRoutes, AppRouter)
│   │
│   ├── services/
│   │   ├── local_database.dart        # Hive wrapper (LocalDataBaseService)
│   │   └── notification_service.dart  # flutter_local_notifications wrapper
│   │
│   └── theme/
│       ├── app_colors.dart            # Centralized color palette
│       ├── app_styles.dart            # Centralized text styles
│       └── app_theme.dart             # ThemeData configuration
│
└── features/
    ├── data/
    │   ├── data_source/
    │   │   ├── local/
    │   │   │   └── repos_local_data_source.dart    # Hive cache operations
    │   │   └── remote/
    │   │       └── repos_remote_data_source.dart   # GitHub API calls via Dio
    │   │
    │   ├── model/
    │   │   ├── repo_model.dart         # RepoModel (fromJson / toJson)
    │   │   └── owner_model.dart        # OwnerModel (fromJson / toJson)
    │   │
    │   └── repo/
    │       └── repos_repository_impl.dart  # ReposRepository implementation
    │
    ├── domain/
    │   ├── entities/
    │   │   ├── repo_entity.dart        # RepoEntity (Equatable)
    │   │   └── owner_entity.dart       # OwnerEntity (Equatable)
    │   │
    │   ├── repositry/
    │   │   └── repos_repository.dart   # Repository interface (abstract class)
    │   │
    │   └── usecase/
    │       ├── get_repo.dart                      # GetReposUseCase
    │       └── sync_repositories_use_case.dart     # SyncRepositoriesUseCase
    │
    └── presentaion/
        ├── cubit/
        │   ├── repo_cubit.dart         # RepoCubit (state management)
        │   └── repo_state.dart         # Sealed RepoState classes
        │
        ├── pages/
        │   └── home_repo_screen.dart   # Main screen with AppBar & BlocProvider
        │
        └── widgets/
            ├── repo_list_view.dart         # Main list view with BlocBuilder
            ├── repo_card.dart              # Individual repository card widget
            ├── repo_skeleton_list.dart     # Skeleton shimmer loading list
            ├── repo_error_widget.dart      # Error state widget with retry
            ├── repo_pagination_loader.dart # Bottom pagination loader indicator
            └── search_text_field.dart      # Search input field widget
```

---

## Tech Stack

| Category | Package | Purpose |
|---|---|---|
| **State Management** | `flutter_bloc` / `bloc` | Cubit-based state management |
| **Dependency Injection** | `get_it` | Service locator pattern |
| **Networking** | `dio` | HTTP client with interceptors & timeouts |
| **Functional Programming** | `dartz` | `Either<Failure, T>` for error handling |
| **Local Database** | `hive` / `hive_flutter` | NoSQL local caching |
| **Routing** | `go_router` | Declarative routing |
| **Responsive UI** | `flutter_screenutil` | Responsive dimensions (`.w`, `.h`, `.sp`) |
| **Equality** | `equatable` | Value equality for entities & states |
| **Loading Skeleton** | `skeletonizer` | Shimmer skeleton effect |
| **Browser Launch** | `url_launcher` | Open URLs in external browser |
| **Notifications** | `flutter_local_notifications` | Local push notifications |
| **Background Tasks** | `workmanager` | Periodic background task execution |

---

## Getting Started

### Prerequisites

- **Flutter SDK** `^3.11.0`
- **Dart SDK** `^3.11.0`
- **Android Studio** or **VS Code** with Flutter extensions
- **Android SDK** (API 21+) or **iOS** (13.0+)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/hamed12232/square_repos.git
cd square_repos

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Build for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## Configuration

### API Configuration

The app connects to the **GitHub REST API**. Configuration is centralized in:

**`lib/core/constants/api_constant.dart`**

```dart
class ApiConstant {
  static const String baseUrl = "https://api.github.com";
  static const String reposEndPoint = "/users/square/repos";
}
```

### Dio Configuration

Dio is configured with timeouts in `service_locator.dart`:

| Setting | Value |
|---|---|
| Connect Timeout | 15 seconds |
| Receive Timeout | 15 seconds |
| Send Timeout | 15 seconds |

---

## Architecture Deep Dive

### Entities (Domain Layer)

Domain entities are pure Dart classes with no framework dependencies:

- **`RepoEntity`** — `id`, `name`, `description`, `fork`, `htmlUrl`, `owner`
- **`OwnerEntity`** — `login`, `htmlUrl`

Both extend `Equatable` for value comparison.

### Models (Data Layer)

Data models extend their corresponding entities and add serialization:

- **`RepoModel`** — `fromJson()` / `toJson()`
- **`OwnerModel`** — `fromJson()` / `toJson()`

### Repository Interface (Domain Layer)

```dart
abstract class ReposRepository {
  Future<Either<Failure, List<RepoEntity>>> getRepos({required int skip, required int limit});
  Future<Either<Failure, List<RepoEntity>>> getRemoteRepos({required int page, required int perPage});
  Future<List<RepoEntity>> getCachedRepos();
  Future<void> saveReposToCache(List<RepoEntity> repos, {bool clear = false});
}
```

### Repository Implementation (Data Layer)

`ReposRepositoryImpl` implements `ReposRepository` and coordinates between:
- **`ReposRemoteDataSource`** — GitHub API via Dio
- **`ReposLocalDataSource`** — Hive local database

### Use Cases (Domain Layer)

| Use Case | Responsibility |
|---|---|
| `GetReposUseCase` | Fetches paginated repositories through the repository |
| `SyncRepositoriesUseCase` | Compares remote vs cached repos, updates cache, sends notification if new repos found |

### Cubit (Presentation Layer)

**`RepoCubit`** manages:
- Paginated loading (`getRepos`, `loadMore`)
- Client-side search filtering (`search`)
- State emissions: `ReposInitial` → `ReposLoading` → `ReposSuccess` / `ReposFailure`

---

## Data Flow

```
┌──────────────┐     ┌────────────┐     ┌──────────────┐     ┌────────────────────┐
│   UI Widget  │────►│  RepoCubit │────►│ GetReposUse  │────►│  ReposRepository   │
│ (BlocBuilder)│     │            │     │    Case      │     │   (Interface)      │
└──────────────┘     └────────────┘     └──────────────┘     └────────────────────┘
                                                                       │
                                                            ┌──────────┴──────────┐
                                                            ▼                     ▼
                                                   ┌────────────────┐   ┌─────────────────┐
                                                   │ RemoteDataSrc  │   │ LocalDataSrc    │
                                                   │  (Dio / API)   │   │  (Hive Cache)   │
                                                   └────────────────┘   └─────────────────┘
```

1. **UI** → triggers `RepoCubit.getRepos()`
2. **Cubit** → calls `GetReposUseCase(skip, limit)`
3. **UseCase** → calls `ReposRepository.getRepos()`
4. **Repository** → tries remote API first
5. **On Success** → caches data locally, returns `Right(repos)`
6. **On Failure** → falls back to local cache; if cache is also empty, returns `Left(failure)`

---

## Error Handling

### Strategy

The project uses **`Either<Failure, T>`** from `dartz` — exceptions never propagate to the UI.

### Error Flow

```
DataSource → catches DioException, SocketException, TimeoutException
     ↓
Repository → converts exceptions into Failure objects
     ↓
UseCase → passes Either<Failure, T> to Cubit
     ↓
Cubit → emits ReposFailure(message)
     ↓
UI → displays error widget with retry button
```

### Failure Types

| Failure | Source |
|---|---|
| `ServerFailure` | API errors (timeout, bad response, connection error) |
| `DatabaseFailure` | Local database read/write errors |
| `CacheFailure` | Cache-specific failures |

### DioException Handling

All `DioException` types are mapped to `ServerException` in `failures.dart`:

- `connectionTimeout` → 408
- `sendTimeout` → 408
- `receiveTimeout` → 408
- `badResponse` → parses server error body
- `connectionError` → 503
- `cancel` → 499
- `badCertificate` → 526
- `unknown` → 520

---

## Caching Strategy

### How It Works

1. **On successful API call** → data is saved to Hive cache
2. **On first page load (`skip == 0`)** → cache is cleared and replaced with fresh data
3. **On paginated loads** → new items are appended to cache (duplicates filtered by ID)
4. **On network failure** → repository automatically falls back to cached data

### Cache Storage

- **Engine**: Hive (NoSQL, lightweight, no native dependencies)
- **Box Name**: `cached_repos`
- **Data Format**: `List<Map<String, dynamic>>` (JSON maps)

> The Presentation layer has no knowledge of caching. The Repository is the single source of truth.

---

## Background Sync

### Overview

The app uses **WorkManager** to run a periodic background task that checks for new repositories every **1 hour**.

### How It Works

1. **WorkManager** fires the `callbackDispatcher` in a background Dart isolate
2. The dispatcher initializes Flutter bindings, Hive, DI, and Notifications
3. **`SyncRepositoriesUseCase`** is called:
   - Fetches page 1 from the GitHub API (10 repos)
   - Reads all cached repositories from Hive
   - Compares repository IDs to detect newly added ones
   - If new repos are found → updates cache and triggers a local notification
4. Task runs with `NetworkType.connected` constraint (requires internet)

### Configuration

```dart
// Registered in main.dart
await Workmanager().registerPeriodicTask(
  'sync_repos_task',
  'sync_repos_periodic',
  frequency: const Duration(hours: 1),
  constraints: Constraints(
    networkType: NetworkType.connected,
  ),
);
```

> **Note**: The background isolate is a separate Dart instance. It re-initializes all dependencies (Hive, GetIt, NotificationService) independently from the main isolate.

---

## Local Notifications

### Setup

**`NotificationService`** (`lib/core/services/notification_service.dart`) wraps `flutter_local_notifications`:

| Method | Description |
|---|---|
| `initialize()` | Configures Android/iOS notification settings and requests permissions |
| `showNotification({title, body})` | Displays a local notification with the given title and body |

### Android Configuration

- **Channel ID**: `sync_channel`
- **Channel Name**: `Background Sync Channel`
- **Priority**: High
- **Importance**: Max
- **Core Library Desugaring**: Enabled in `android/app/build.gradle.kts`

### Test Button

A **"Test Notification"** button is available in the AppBar on the home screen for manual testing:

```
Title: "New Repositories"
Body:  "This is a test notification."
```

---

## Search

### Implementation

Client-side search is implemented entirely in the **Presentation layer** (no API calls):

1. A `SearchTextField` widget is placed above the repository list
2. On text change → calls `cubit.search(query)`
3. `RepoCubit` filters the in-memory `repos` list
4. Search is **case-insensitive** and matches against:
   - Repository **name**
   - Repository **description**
   - Owner **username** (login)
5. If query is empty → all loaded repositories are displayed

> Pagination and cache logic remain completely unchanged.

---

## UI Components

### Screens

| Screen | File | Description |
|---|---|---|
| Home | `home_repo_screen.dart` | Main screen with AppBar, BlocProvider, and Test Notification button |

### Widgets

| Widget | File | Description |
|---|---|---|
| `RepoListView` | `repo_list_view.dart` | Main list with BlocBuilder, handles all states |
| `RepoCard` | `repo_card.dart` | Repository card with fork indicator and long-press dialog |
| `SearchTextField` | `search_text_field.dart` | Search input field with cubit integration |
| `RepoSkeletonList` | `repo_skeleton_list.dart` | Skeleton shimmer loading placeholder |
| `RepoErrorWidget` | `repo_error_widget.dart` | Error state with message and retry button |
| `RepoPaginationLoader` | `repo_pagination_loader.dart` | Bottom loading spinner for pagination |

### Visual Features

- **Fork Indicator**: Light green background (`#E8F5E9`) for original repos, white for forks
- **Long-Press Dialog**: Opens an AlertDialog with two options:
  - Open **repository URL** in browser
  - Open **owner profile URL** in browser
- **Skeleton Loading**: Shimmer effect while initial data is loading

---

## Dependency Injection

All dependencies are registered in **`lib/core/di/service_locator.dart`** using **GetIt**, following this order:

```
1. External Services     → Dio, LocalDataBaseService, NotificationService
2. DataSources           → ReposRemoteDataSource, ReposLocalDataSource
3. Repositories          → ReposRepository (LazySingleton)
4. UseCases              → GetReposUseCase, SyncRepositoriesUseCase (LazySingleton)
5. Cubits                → RepoCubit (Factory — new instance per screen)
```

### Registration Rules

| Type | Registration |
|---|---|
| Services | `LazySingleton` |
| DataSources | `LazySingleton` |
| Repositories | `LazySingleton` |
| UseCases | `LazySingleton` |
| Cubits | `Factory` |

---

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run with verbose output
flutter test --verbose

# Run a specific test file
flutter test test/widget_test.dart
```

### Static Analysis

```bash
# Run Dart analyzer
flutter analyze
```

---

## Git Conventions

This project uses **Conventional Commits**:

```
feat(repo): implement pagination
fix(cache): resolve hive deserialization issue
refactor(repository): split remote datasource
feat(sync): implement background sync task and local notifications
```

### Format

```
<type>(<scope>): <description>
```

| Type | Purpose |
|---|---|
| `feat` | A new feature |
| `fix` | A bug fix |
| `refactor` | Code refactoring |
| `docs` | Documentation changes |
| `style` | Code style changes (formatting, etc.) |
| `test` | Adding or modifying tests |
| `chore` | Build process or auxiliary tool changes |

---

## License

This project is for educational purposes.
