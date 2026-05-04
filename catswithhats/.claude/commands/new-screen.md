---
name: new-screen
description: Creates a new SwiftUI screen following the catswithhats architecture pattern. Use this whenever adding any new screen to the app — even if the user just says "add a profile screen" or "create a settings page". Generates *State.swift, *Store.swift, and *Screen.swift with the correct UDF pattern, placed in the right directory. Invoke as /new-screen <ScreenName> (e.g. /new-screen Profile, /new-screen Settings).
---

# New Screen

Generate a new screen called `$ARGUMENTS` following the catswithhats architecture.

## Architecture rules

- **No UIKit, no KMP** — SwiftUI only
- Screen files: `*Screen.swift` — SwiftUI View, owns the Store
- Store files: `*Store.swift` — `@Observable` class, exposes `uiState`
- State files: `*State.swift` — plain struct, pure data, no logic
- View component files (reusable sub-views): `*View.swift`
- Navigation: `NavigationStack` + `.navigationDestination(for: AppRoute.self)` only

## File structure

Place all three files at:
```
catswithhats/ui/<feature-name-lowercase>/
  <Name>State.swift
  <Name>Store.swift
  <Name>Screen.swift
```

## UiState

Every Store uses the shared wrapper from `core/UiState.swift`:
```swift
enum UiState<T> {
    case loading
    case error(String)
    case content(T)
}
```

## Templates

### `<Name>State.swift`
```swift
struct <Name>State {
    // Add data properties here
}
```
Pure data, no methods, no logic.

### `<Name>Store.swift`
```swift
import Foundation

@Observable
final class <Name>Store {
    private(set) var uiState: UiState<<Name>State> = .loading

    private let databaseService: any DatabaseService

    init(databaseService: any DatabaseService) {
        self.databaseService = databaseService
    }

    func load() async {
        // TODO: fetch data
        uiState = .content(<Name>State())
    }

    // Add user-intent methods here, e.g.:
    // func didTapItem(_ item: Item) { ... }
}
```

User intents are plain methods on the Store — no action enums needed.

### `<Name>Screen.swift`
```swift
import SwiftUI

struct <Name>Screen: View {
    @State private var store: <Name>Store

    init(databaseService: any DatabaseService) {
        _store = State(initialValue: <Name>Store(databaseService: databaseService))
    }

    var body: some View {
        switch store.uiState {
        case .loading:
            ProgressView()
        case .error(let message):
            Text(message)
                .foregroundStyle(.red)
        case .content(let state):
            contentView(state)
        }
    }

    private func contentView(_ state: <Name>State) -> some View {
        // Build the screen UI here
        Text("<Name> Screen")
            .navigationTitle("<Name>")
    }
}

#Preview {
    <Name>Screen(databaseService: FirebaseDatabaseService())
}
```

- The Screen owns the Store via `@State`
- Call `store.load()` with `.task { await store.load() }`
- Push navigation with `NavigationLink(value: AppRoute.<destination>)`

## Navigation

After creating the screen, add its route to `ui/AppRoute.swift`:
```swift
enum AppRoute: Hashable {
    // ... existing cases
    case <nameLowercase>   // add this
}
```

Then wire it up in `ContentView.swift`:
```swift
.navigationDestination(for: AppRoute.self) { route in
    switch route {
    // ... existing cases
    case .<nameLowercase>:
        <Name>Screen(databaseService: databaseService)
    }
}
```

## Checklist

After generating the files, remind the user to:
1. Add the new files to the Xcode project target (drag into Xcode or use Add Files)
2. Add the route to `AppRoute.swift`
3. Wire the destination in `ContentView.swift`
