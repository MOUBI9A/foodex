# 🍽️ FoodEx – Community Food Marketplace

[![Flutter](https://img.shields.io/badge/Flutter-3.24%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.4%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Android](https://img.shields.io/badge/Android-Ready-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com)
[![iOS](https://img.shields.io/badge/iOS-Tested-000000?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![Web](https://img.shields.io/badge/Web-PWA-4285F4?style=for-the-badge&logo=googlechrome&logoColor=white)](https://web.dev/progressive-web-apps/)
[![Desktop](https://img.shields.io/badge/Desktop-macOS%2FWin%2FLinux-4C566A?style=for-the-badge&logo=flutter&logoColor=white)](https://docs.flutter.dev/platform-integration/desktop)

FoodEx connects customers with local home chefs through a polished, multi-platform Flutter app inspired by Moroccan aesthetics. The project now runs on a unified Clean Architecture stack—legacy `lib/view/*` files have been removed so every screen lives under `lib/presentation/pages` or `lib/features`.

---

## ✨ Feature Highlights
- **Customers:** curated menu browsing, secure wallet with MAD currency, order tracking, reviews, and personalized recommendations.
- **Home Chefs:** menu/product management, live order queue, pantry inventory, analytics, and earnings dashboards.
- **Delivery Drivers:** assignment queue, optimized routing, payout tracking, and availability toggles.
- **Admins:** dashboard widgets for revenue, orders, health metrics, and system alerts (see `lib/features/admin`).

Extended feature descriptions live in [`docs/FEATURES_DOCUMENTATION.md`](docs/FEATURES_DOCUMENTATION.md).

---

## 📁 Repository Layout
```
lib/
├── core/            # Constants, themes, routing scaffolds, utilities
├── data/            # DTOs, data sources, repositories, mock data
├── domain/          # Entities + repository contracts
├── features/        # Vertical feature slices (admin/chef/customer)
├── presentation/    # Cross-role pages, widgets, and providers
├── services/        # API, cache, websocket, and platform services
└── main.dart        # App bootstrap and DI wiring

docs/                # Project, deployment, and migration guides
scripts/             # Import fixes, cleanup, and automation helpers
tool/ci_checks.sh    # Aggregated lint/test runner for CI
run-*.sh             # Platform-specific launch shortcuts
```
> ✅ `lib/view/*` was retired in this clean-up—use the presentation or feature folders for UI work.

---

## 🚀 Getting Started
### Prerequisites
- Flutter 3.24+ / Dart 3.4+ (`fvm` recommended for pinning)
- Xcode 15+, Android Studio/SDK 34+, or desktop toolchains
- A Firebase/REST backend or the included mock repositories

### Installation
```bash
git clone https://github.com/MOUBI9A/foodex.git
cd food_delivery_meal-main
flutter pub get
```

---

## ▶️ Running the App
| Target    | Command                                                                 |
|-----------|--------------------------------------------------------------------------|
| Android   | `flutter run -d android` or `./run-android.sh`                           |
| iOS       | `flutter run -d ios` (requires `cd ios && pod install` the first time)   |
| Web       | `flutter run -d chrome` or `./run-web.sh`                                |
| macOS     | `flutter run -d macos` or `./run-macos.sh`                               |
| Windows   | `flutter run -d windows` or `run-windows.bat`                            |
| Linux     | `flutter run -d linux` or `./run-linux.sh`                               |

For a one-stop multi-platform build:
```bash
./build_all_platforms.sh all   # or pass web/android/ios/macos/windows/linux
```

---

## 🛠️ Architecture Snapshot
- **Pattern:** Clean Architecture with explicit `core`, `data`, `domain`, `features`, and `presentation` layers.
- **State:** Provider-based presenters plus emerging Riverpod providers where finer-grained reactivity is required.
- **Navigation:** GoRouter scaffolding (`lib/core/routes/app_router.dart`) ready for full adoption; temporary `Navigator` routes live in `lib/core/constants/routes.dart`.
- **Networking:** `dio` and `http` clients with websocket helpers, backed by environment configs in `lib/core`.
- **Storage:** Hive for structured caches and SharedPreferences for lightweight persistence.
- **Realtime & System Services:** `web_socket_channel`, `local_db_service.dart`, `api_service.dart`, and `service_locator.dart` handle IO + dependency injection.
- **Design System:** Metropolis & Poppins fonts, `lib/core/theme(s)` for colors/spacing, and reusable widgets in `lib/presentation/widgets`.

Detailed diagrams live in [`docs/PROJECT_STRUCTURE.md`](docs/PROJECT_STRUCTURE.md) and [`docs/MIGRATION.md`](docs/MIGRATION.md).

---

## ✅ Testing & Quality
```bash
flutter test                         # unit + widget tests
flutter test --coverage              # with lcov output
flutter drive --target=integration_test/test_app.dart   # integration/e2e
dart run tool/ci_checks.sh           # lint + formatting + tests bundle
```
- Widget and provider suites live in `test/unit` and `test/widget`.
- Integration harnesses are under `integration_test/`.
- Mock helpers reside in `test/test_helpers/`.

---

## 📦 Tooling & Scripts
- `scripts/fix_all_imports.sh` / `scripts/comprehensive_import_fix.sh`: repair package imports after moves.
- `scripts/final_import_fixes.sh`: shortcut for CI-ready import cleanup.
- `push_to_github.sh`, `run.sh`, and platform-specific launchers simplify common workflows.
- `docs/DEPLOYMENT.md` plus `docs/TESTING_DEPLOYMENT_SUMMARY.md` cover release steps.

---

## 🧭 Documentation Map
- [`docs/FINAL_DOCUMENTATION.md`](docs/FINAL_DOCUMENTATION.md) – end-to-end delivery summary.
- [`docs/FEATURE_IMPLEMENTATION_SUMMARY.md`](docs/FEATURE_IMPLEMENTATION_SUMMARY.md) – phase notes per feature.
- [`docs/INGREDIENT_LOGIC_AND_ADMIN_PANEL.md`](docs/INGREDIENT_LOGIC_AND_ADMIN_PANEL.md) – chef/admin domain deep dive.
- [`docs/BACKEND_INTEGRATION_GUIDE.md`](docs/BACKEND_INTEGRATION_GUIDE.md) & [`docs/API_TECHNICAL_SPECIFICATIONS.md`](docs/API_TECHNICAL_SPECIFICATIONS.md) – API contracts.
- [`docs/COMPREHENSIVE_TESTING_REPORT.md`](docs/COMPREHENSIVE_TESTING_REPORT.md) – QA evidence.

---

## 🤝 Contributing
1. Create a feature branch and run `flutter format . && dart analyze`.
2. Add/adjust tests near the code you touch.
3. Use the scripts in `tool/` and `scripts/` to keep imports + CI happy.
4. Open a PR referencing the relevant document or roadmap item.

---

FoodEx is production-ready across mobile, web, and desktop, and the repository is now free of deprecated `lib/view` artifacts. Build your feature inside `lib/features/*` or `lib/presentation/*`, lean on the shared design system, and ship great community-powered food experiences.  
Bon appétit! 🇲🇦

## 🚀 Deployment

### **Web Deployment**
```bash
flutter build web --release
# Deploy to your hosting provider
```

### **Mobile App Stores**
```bash
# Android Play Store
flutter build appbundle --release

# iOS App Store  
flutter build ios --release
```

### **Desktop Distribution**
```bash
# macOS App Store
flutter build macos --release

# Windows Microsoft Store
flutter build windows --release

# Linux Snap Store
flutter build linux --release
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**MOUBI9A**
- GitHub: [@MOUBI9A](https://github.com/MOUBI9A)
- Email: moubi9a@foodex.ma

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for design inspiration
- Moroccan culinary culture for app concept
- Open source community for contributions

---

<div align="center">

**🍽️ Built with ❤️ for the food community**

[⭐ Star this repo](https://github.com/MOUBI9A/foodex) • [🐛 Report Bug](https://github.com/MOUBI9A/foodex/issues) • [✨ Request Feature](https://github.com/MOUBI9A/foodex/issues)

</div>
