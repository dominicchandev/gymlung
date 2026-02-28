# Create Swift File Skill

## Description
Creates a new Swift file in the GymLung Xcode project. Since this project uses `PBXFileSystemSynchronizedRootGroup`, files placed on disk are automatically discovered by Xcode — no manual `project.pbxproj` editing needed.

## Steps

### 1. Determine File Path
- Decide which directory the file belongs in based on the project structure:
  - `Root/` — App coordinator and navigation
  - `Views/Onboarding/` — Onboarding flow views
  - `Views/Onboarding/Pages/` — Individual onboarding question pages
  - `Views/Main/` — Main app tab views
  - `Data/Model/` — SwiftData models
  - `Managers/` — Business logic managers
  - `Common/Extensions/` — Swift extensions
  - `Common/Components/` — Reusable UI components

### 2. Check for Duplicates
- Use `ls` or `find` to verify no file with the same name exists at the target path.

### 3. Create the File
- Use the Write tool to create the file at: `GymLung/GymLung/<subdirectory>/<FileName>.swift`
- Include the standard file header:
```swift
//
//  <FileName>.swift
//  GymLung
//
//  Created by Chan Tin Lok on <date>.
//
```

### 4. Verify
- Confirm the file exists on disk with `ls`.

## Important Notes
- All user-facing strings must be in Cantonese (廣東話)
- Follow the existing code patterns in the project
- Use SwiftUI for all views
- Use SwiftData for all persistence
- Use `@Observable` pattern for managers (not ObservableObject)
