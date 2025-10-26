#!/usr/bin/env bash
set -euo pipefail
flutter --version
flutter pub get
flutter analyze
flutter test --coverage
flutter build web --release
