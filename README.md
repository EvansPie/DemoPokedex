# 🧑‍💻 DemoPokedex

**DemoPokedex** is a SwiftUI-based iOS application that allows users to browse and interact with Pokemon data effortlessly.

## ✨ Features

- Browse a list of Pokemon with detailed information.
- Filter Pokemon by type and region.
- Sort Pokemon by name or HP (ascending/descending).
- View comprehensive details about each Pokemon.

## ⚙️ Prerequisites

1. **Xcode 16.2** (not tested with other versions).
2. Clone the whole repository. Ensure the subprojects are organized as described in the [Folder Structure](#🗂️-folder-structure) section.

   > _Note:_ `DemoPokedex` has a local dependency on `DemoPokedexCoreKit`.

## 🚀 Cloning the Repository

### DemoPokedex

That's a parent repository that contains the following:

1. 📲 DemoPokedex Project
2. 📦 DemoPokedexCoreKit
3. 🎁 Optional: DemoPokedexServer

URL: https://github.com/EvansPie/DemoPokedex.git

```bash
git clone https://github.com/EvansPie/DemoPokedex.git
```

### 📲 DemoPokedex Project

The demo project, featuring 3 screens:

1. A list of Pokemons
2. A Pokemon detail view
3. A filters screen

### About the DemoPokedexServer

A simple Node.js server to serve Pokemon JSON data if https://dummyapi.online is unavailable.

#### DemoPokedexServer Prerequisites

- Installed **Node.js** and **npm**

#### Run DemoPokedexServer

Navigate to the `DemoPokedexServer` directory and run:

```bash
node server.js
```

Once the server is running, update the app's base URL to http://localhost:8000.
To configure this, change DevelopmentEnvironment.current from `.dev` to `.local`.

> _Note:_ The Pokemons served are mock data, so bear in mind that not all Pokemons are there, and have their evolutions included. Moreover, their evolutions might be included but the evolved Pokemon is not included in the data. In this case the evolved Pokemons are not presented on the UI.

## 🗂️ Folder Structure

Make sure that the folders are structured as below

```
DemoPokedex
 |- DemoPokedex
 |- DemoPokedexCoreKit
 |- DemoPokedexServer
```

## 🛠️ Architecture

### Modularization - `DemoPokedexCoreKit`
- Provides extensions and helper functions.
- Implements a generic protocol for `CustomError` with improved error handling.
- Includes `APIClient` for network requests and `MockAPIClient` for testing.
- Contains independent unit tests.

### MVVM Design Pattern 
- Views observe state updates from their ViewModels.

### Separation of Concerns
- **Data Handling**: Managed by DataService.

    > _Note:_ When I started the project the `DataService` was responsible for filtering and sorting, but since the `DataService` is probably going to become a god object, I moved out filtering and sorting.
- **Filtering and Sorting**: Delegated to `FilterAndSort` with dependency injection.
- **UI Logic**: Centralized in ViewModels.
- **Business Logic**: Minimal at this stage.

### Data Modelling
- The Pokemon model decodes and transforms server data:
    - Splits the `location` string into `region` and `road` during decoding for easier filtering of regions. That's because the `Pokemon` server-side model lacks region-specific fields, requiring app-side parsing. Ideally, this logic should be handled server-side.
    - Uses an `enum` for Pokemon types since they are static and predefined.

## 🧪 Testing

You can find unit tests on both:

- `DemoPokedex`
- `DemoPokedexCoreKit`

You can find one *not-so-meaningful* UI test on:

- `DemoPokedex`

    > _Note:_  I prefer to align UI identifiers across iOS and Android and write UI tests using Appium with TypeScript. This approach reduces the effort required to write tests, ensuring both platforms are covered with a single test suite that serves as the source of truth. On the downside, setting up a test suite with Appium requires considerable effort, particularly when configuring the CI/CD pipeline. However, this setup is typically a one-time task.

## 🚀 Improvements for Production-Readiness

- **Data Persistence**: Use CoreData or another persistent store.
- **Memory Management**: Check for memory leaks and retain cycles (*handled at a basic level*).
- **Threading**: Optimize and ensure thread safety (*handled at a basic level*).
- **Analytics**: Add meaningful event tracking.
- **Pull-to-Refresh**: Implement in `HomeView`.
- **Pagination**: Add support for paginated Pokemon requests.
- **Real-Time Updates**: Listen to server updates and refresh data, or at the very least refresh data when the app enters the foreground.
- **Abstraction Improvements**:
    - Tag Abstraction: Introduce a protocol (e.g. `TagViewRepresentable`) for reusable tags like "Fire" or filters.
    - Generalize filtering logic with a protocol-based approach, e.g.:
        ```swift
        func filter<T: Filterable>(dataSource: [T], with filters: FiltersProtocol) -> [T]
        ```
- **Testing**: Write comprehensive unit and UI tests (*done at a basic level*).
- **CI/CD Pipeline**:
    - Automate builds, tests, and App Store distribution.
    - Optionally tag commits upon successful pipeline completion (e.g., on commit `release: v1.0.0` tag with `1.0.0`).
