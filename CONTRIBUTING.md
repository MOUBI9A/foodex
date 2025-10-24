# Contributing to FoodEx

First off, thank you for considering contributing to FoodEx! It's people like you that make FoodEx such a great platform for connecting food lovers with local home chefs.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Workflow](#development-workflow)
- [Style Guidelines](#style-guidelines)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Community](#community)

## Code of Conduct

This project and everyone participating in it is governed by the [FoodEx Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [support@foodex.ma](mailto:support@foodex.ma).

## Getting Started

### Prerequisites

- Flutter SDK 3.32.5 or higher
- Dart SDK 3.8.1 or higher
- Git
- Your favorite IDE (VS Code, Android Studio, IntelliJ IDEA)
- Android Studio (for Android development)
- Xcode (for iOS development, macOS only)

### Setting Up Your Development Environment

1. **Fork the repository**
   ```bash
   # Click the 'Fork' button on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/foodex.git
   cd foodex
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/MOUBI9A/foodex.git
   ```

4. **Install dependencies**
   ```bash
   flutter pub get
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report. Following these guidelines helps maintainers and the community understand your report, reproduce the behavior, and find related reports.

**Before Submitting A Bug Report:**
- Check the [documentation](docs/) for a list of common questions and problems.
- Ensure the bug was not already reported by searching on GitHub under [Issues](https://github.com/MOUBI9A/foodex/issues).
- Determine which repository the problem should be reported in.
- Perform a cursory search to see if the problem has already been reported.

**How Do I Submit A (Good) Bug Report?**

Bugs are tracked as [GitHub issues](https://github.com/MOUBI9A/foodex/issues). Create an issue and provide the following information:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples to demonstrate the steps**
- **Describe the behavior you observed after following the steps**
- **Explain which behavior you expected to see instead and why**
- **Include screenshots or animated GIFs** if possible
- **Include your environment details:**
  - Flutter version (`flutter --version`)
  - Dart version (`dart --version`)
  - Device/Simulator information
  - OS version

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion, including completely new features and minor improvements to existing functionality.

**Before Submitting An Enhancement Suggestion:**
- Check if there's already a feature request or ongoing discussion
- Check if you're using the latest version
- Read the [documentation](docs/) to make sure the feature doesn't already exist

**How Do I Submit A (Good) Enhancement Suggestion?**

Enhancement suggestions are tracked as [GitHub issues](https://github.com/MOUBI9A/foodex/issues). Create an issue and provide the following information:

- **Use a clear and descriptive title**
- **Provide a step-by-step description of the suggested enhancement**
- **Provide specific examples to demonstrate the steps**
- **Describe the current behavior** and **explain which behavior you expected to see instead**
- **Explain why this enhancement would be useful**
- **List some other applications where this enhancement exists** (if applicable)

### Your First Code Contribution

Unsure where to begin contributing? You can start by looking through these `good-first-issue` and `help-wanted` issues:

- [Good first issues](https://github.com/MOUBI9A/foodex/labels/good%20first%20issue) - issues which should only require a few lines of code
- [Help wanted issues](https://github.com/MOUBI9A/foodex/labels/help%20wanted) - issues which should be a bit more involved

### Pull Requests

The process described here has several goals:

- Maintain FoodEx's quality
- Fix problems that are important to users
- Engage the community in working toward the best possible FoodEx
- Enable a sustainable system for FoodEx's maintainers to review contributions

## Development Workflow

1. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix-name
   ```

2. **Make your changes**
   - Write clean, maintainable code
   - Follow the [style guidelines](#style-guidelines)
   - Add tests if applicable
   - Update documentation as needed

3. **Test your changes**
   ```bash
   # Run tests
   flutter test
   
   # Run integration tests
   flutter test integration_test
   
   # Run static analysis
   flutter analyze
   
   # Format code
   flutter format .
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add amazing feature"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request**
   - Go to the original repository
   - Click "New Pull Request"
   - Choose your branch
   - Fill out the PR template

## Style Guidelines

### Dart Style Guide

We follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style) with some additional conventions:

#### Code Formatting

- Use `flutter format` to automatically format your code
- Maximum line length: 80 characters (enforced by formatter)
- Use 2 spaces for indentation
- Always use trailing commas for better formatting

#### Naming Conventions

- **Classes**: `PascalCase` (e.g., `UserProfile`, `OrderService`)
- **Files**: `snake_case` (e.g., `user_profile.dart`, `order_service.dart`)
- **Variables**: `camelCase` (e.g., `userName`, `orderTotal`)
- **Constants**: `lowerCamelCase` (e.g., `maxRetryAttempts`, `defaultTimeout`)
- **Enums**: `PascalCase` for the enum, `camelCase` for values

```dart
enum OrderStatus {
  pending,
  confirmed,
  delivered,
}
```

#### Documentation

- Use `///` for public API documentation
- Use `//` for implementation comments
- Document all public classes, methods, and properties

```dart
/// Represents a food menu item.
///
/// This class contains all information about a menu item including
/// its name, price, and availability status.
class MenuItem {
  /// The unique identifier for this menu item.
  final String id;
  
  /// The display name of the menu item.
  final String name;
  
  // Private implementation detail
  final double _basePrice;
}
```

#### Architecture

We use **Clean Architecture** with the following layers:

```
lib/
├── core/                 # Shared utilities, constants, themes
├── data/                 # Data sources, repositories, models
├── domain/               # Business logic, entities, use cases
└── presentation/         # UI, widgets, pages, providers
```

- Keep business logic in the `domain` layer
- Use repositories to abstract data sources
- Use providers (Riverpod) for state management
- Keep widgets small and focused

### UI/UX Guidelines

- Follow Material Design 3 guidelines
- Maintain consistent spacing (8px grid system)
- Use the app's color scheme (`TColor` class)
- Ensure accessibility (screen readers, contrast ratios)
- Test on different screen sizes
- Implement proper loading and error states

### Testing Guidelines

- Write unit tests for business logic
- Write widget tests for UI components
- Write integration tests for critical user flows
- Aim for 80% code coverage
- Use descriptive test names

```dart
test('should return user profile when API call is successful', () {
  // Arrange
  // Act
  // Assert
});
```

## Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that don't affect code meaning (formatting, etc.)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Changes to build process or auxiliary tools

### Examples

```bash
feat(auth): add biometric authentication

fix(cart): resolve crash when removing items

docs(readme): update installation instructions

test(orders): add integration tests for order flow

chore(deps): upgrade flutter to 3.32.5
```

## Pull Request Process

1. **Update Documentation**: Ensure any new features are documented
2. **Update Tests**: Add or update tests as needed
3. **Update CHANGELOG.md**: Add a note under the "Unreleased" section
4. **Run All Checks**: Ensure tests pass and code is formatted
5. **Fill PR Template**: Provide all requested information
6. **Request Review**: Tag relevant maintainers
7. **Address Feedback**: Make requested changes promptly
8. **Squash Commits**: Before merging, squash commits if requested

### PR Checklist

- [ ] My code follows the style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix/feature works
- [ ] New and existing unit tests pass locally
- [ ] Any dependent changes have been merged and published

## Community

### Communication Channels

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: Questions and discussions
- **Email**: [support@foodex.ma](mailto:support@foodex.ma)

### Recognition

Contributors are recognized in:
- README.md contributors section
- Release notes for significant contributions
- Special mentions in community updates

## License

By contributing to FoodEx, you agree that your contributions will be licensed under the same license as the project (see [LICENSE](LICENSE) file).

## Questions?

Don't hesitate to ask! You can:
- Open an issue with the `question` label
- Start a discussion on GitHub Discussions
- Email us at [support@foodex.ma](mailto:support@foodex.ma)

---

Thank you for contributing to FoodEx! 🍽️ Your efforts help make food delivery better for everyone.
