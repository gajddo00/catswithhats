# Cats with Hats — Agent Guide

## What this is
A catswithhats vending machine iOS app where users collect cats wearing hats.
Built with SwiftUI targeting iOS 26.

## Project structure
```
CatsWithHats/
├── Catswithhats/         # App entry point
├── Models/               # Data models & enums
├── Feature/              # SwiftUI screens
├── Models/               # Data models
└── Resources/            # Assets, fonts
```

## Key files
- `Models/CatImages.swift` — `CatImage` enum, `ImageBackgroundShape`, `CatImageView`, `CatCardView`
- `Engine/GachaEngine.swift` — weighted random draw logic
- `App/CatsWithHatsApp.swift` — app entry + `AppStore` environment object

## Cat image assets
10 image sets in the asset catalog:
`astronaut`, `artist`, `chef`, `chef_2`, `detective`, `farmer`, `firefighter`, `pilot`, `pirate`, `wizard`

Note: `chef_2` maps to enum case `.chef2` (rawValue = `"chef_2"`).

## Image shape options
`ImageBackgroundShape` enum: `.circle`, `.square`, `.rounded` (default)
Pass via `CatImageView(cat:, size:, shape:)`.

## Rarity tiers
| Tier | Weight |
|------|--------|
| Common | 55% |
| Rare | 28% |
| Super Rare | 13% |
| Secret | 4% |

## Design rules
- Animations: `.spring()` and `.easeInOut` only — no SceneKit, SpriteKit, or Metal
- All transitions under 0.6s
- Font: rounded/bubbly — use `.rounded` design on system font
- Palette: pastel pinks, creamy yellows, mint greens with bold outlines

## Git
- Remote: `ssh://github.com/gajddo00/catswithhats`
- Main branch: `main`
- Preferred merge strategy: `git pull --no-rebase origin main`
