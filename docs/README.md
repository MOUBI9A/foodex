# FOODEx Documentation

Welcome to the FOODEx technical documentation.

## Available Guides

### [MIGRATION.md](./MIGRATION.md) 🔄
Complete guide for the Phase 3 architecture migration:
- New project structure (feature-first)
- GoRouter navigation patterns
- Riverpod state management
- How to add new features
- Testing strategies
- Migration checklist

**Start here if you're new to the codebase or upgrading from an older version.**

---

## Quick Start

### For New Developers

1. Read [MIGRATION.md](./MIGRATION.md) to understand the architecture
2. Check `lib/features/` for examples of feature modules
3. Review `lib/core/constants/routes.dart` for navigation
4. See `test/widget/` and `test/unit/` for testing patterns

### For Existing Contributors

If you've worked on FOODEx before Phase 3:
- `lib/view/*` is **deprecated** — use `lib/features/` or `lib/presentation/pages/`
- Navigation now uses **GoRouter** — see route examples in MIGRATION.md
- State management is **Riverpod-first** — providers are in `{feature}/providers/`
- All data uses **Hive** for offline-first persistence

---

## Architecture Overview

```
Presentation Layer (UI)
    ↓
Feature Modules (business logic + screens)
    ↓
Providers (Riverpod state)
    ↓
Repositories (data access)
    ↓
Local DB (Hive) + Mock Data
```

---

## Key Technologies

- **Flutter 3+** — UI framework
- **GoRouter 14+** — Declarative routing
- **Riverpod 2+** — State management
- **Hive** — Offline-first local storage
- **Material 3** — Design system (with custom tokens)

---

## Project Structure

```
lib/
├── core/           # Shared utilities, theme, constants
├── data/           # Models, repositories, mock data
├── features/       # Feature modules (customer, chef, admin)
├── presentation/   # Shared UI layer
└── main.dart       # App entry with GoRouter + Riverpod
```

See [MIGRATION.md](./MIGRATION.md) for detailed structure.

---

## Getting Help

1. **Architecture questions** → [MIGRATION.md](./MIGRATION.md)
2. **Code examples** → Check `lib/features/*/screens/` for patterns
3. **Testing** → See `test/widget/` and `test/unit/`
4. **Navigation** → Review `lib/core/constants/routes.dart`

---

**Last Updated:** October 26, 2025  
**Migration Phase:** 3 — GoRouter + Feature-First Structure
