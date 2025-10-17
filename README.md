# TaxLien.online Mobile App

A modern, feature-rich mobile application for investing in tax liens, built with Flutter and integrated with Magento API.

## 🚀 Features

- **Modern UI/UX**: Beautiful, intuitive interface with Material Design 3
- **Magento Integration**: Full integration with Magento e-commerce platform
- **Authentication**: Secure user authentication and profile management
- **Product Catalog**: Browse and search tax lien products
- **Shopping Cart**: Add, remove, and manage cart items
- **Order Management**: View order history and track orders
- **Wishlist**: Save favorite products for later
- **Dark/Light Theme**: Support for both light and dark themes
- **Multi-language**: Internationalization support
- **Offline Support**: Basic offline functionality
- **Push Notifications**: Real-time updates and alerts

## 🏗️ Architecture

### Modern State Management
- **Riverpod**: Centralized state management with providers
- **Clean Architecture**: Separation of concerns with feature-based organization
- **Dependency Injection**: Proper dependency management

### Navigation
- **GoRouter**: Declarative routing with deep linking support
- **Type-safe Navigation**: Compile-time route safety

### API Integration
- **Magento REST API**: Full integration with Magento e-commerce
- **Dio**: Advanced HTTP client with interceptors
- **Error Handling**: Comprehensive error handling and user feedback

## 📱 Screenshots

*Screenshots will be added here*

## 🛠️ Technology Stack

- **Framework**: Flutter 3.2.3+
- **Language**: Dart 3.2.3+
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **HTTP Client**: Dio
- **UI Components**: Material Design 3
- **Icons**: Material Icons + Custom Icons
- **Fonts**: Inter (Google Fonts)
- **Storage**: SharedPreferences + Secure Storage
- **Analytics**: Firebase Analytics (optional)
- **Notifications**: Firebase Cloud Messaging (optional)

## 📋 Prerequisites

- Flutter SDK 3.2.3 or higher
- Dart SDK 3.2.3 or higher
- Android Studio / VS Code
- iOS development tools (for iOS builds)
- Magento backend with REST API enabled

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/taxlien-mobile-app.git
cd taxlien-mobile-app
```

### 2. Install Dependencies

Run the installation script:

```bash
./install_dependencies.sh
```

Or manually:

```bash
flutter pub get
flutter gen-l10n
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 3. Configure Environment

Create a `.env` file in the root directory:

```env
MAGENTO_BASE_URL=https://your-magento-instance.com
MAGENTO_API_KEY=your-api-key
ENABLE_ANALYTICS=true
ENABLE_NOTIFICATIONS=true
```

### 4. Run the App

```bash
# Development
flutter run

# Production build
flutter build apk --release
flutter build ios --release
```

## 🏛️ Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants
│   ├── theme/              # Theme and styling
│   ├── models/             # Data models
│   ├── services/           # Business logic services
│   ├── navigation/         # Routing configuration
│   ├── widgets/            # Reusable widgets
│   └── utils/              # Utility functions
├── features/               # Feature-based modules
│   ├── auth/              # Authentication feature
│   ├── theme/             # Theme management
│   ├── localization/      # Internationalization
│   └── magento/           # Magento integration
└── main.dart              # App entry point
```

## 🎨 Design System

### Colors
- **Primary**: Deep Blue (#1E3A8A) - Trust and stability
- **Secondary**: Gold (#F59E0B) - Wealth and prosperity
- **Success**: Green (#10B981) - Growth and success
- **Warning**: Orange (#F97316) - Caution
- **Error**: Red (#EF4444) - Danger

### Typography
- **Font Family**: Inter
- **Weights**: Regular (400), Medium (500), SemiBold (600), Bold (700)

### Spacing
- **Base Unit**: 4px
- **Scale**: xs(4), sm(8), md(16), lg(24), xl(32), xxl(48), xxxl(64)

## 🔧 Configuration

### Magento API Configuration

The app integrates with Magento REST API. Configure the following endpoints:

```dart
// Base URL
https://your-magento-instance.com/rest/V1

// Required endpoints
- /integration/customer/token (Authentication)
- /customers (Customer management)
- /products (Product catalog)
- /guest-carts (Cart management)
- /categories (Category management)
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `MAGENTO_BASE_URL` | Magento instance URL | `https://taxlien.online` |
| `ENABLE_ANALYTICS` | Enable analytics tracking | `true` |
| `ENABLE_NOTIFICATIONS` | Enable push notifications | `true` |

## 🧪 Testing

### Run Tests

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Coverage report
flutter test --coverage
```

### Test Structure

- **Unit Tests**: Business logic and utilities
- **Widget Tests**: UI component testing
- **Integration Tests**: End-to-end user flows

## 📦 Building

### Android

```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# App bundle for Play Store
flutter build appbundle --release
```

### iOS

```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release
```

## 🚀 Deployment

### Android (Google Play Store)

1. Build the app bundle:
   ```bash
   flutter build appbundle --release
   ```

2. Upload to Google Play Console

### iOS (App Store)

1. Build the app:
   ```bash
   flutter build ios --release
   ```

2. Archive and upload via Xcode

## 🔒 Security

- **Secure Storage**: Encrypted storage for sensitive data
- **Token Management**: Secure token handling
- **Input Validation**: Comprehensive form validation
- **Network Security**: HTTPS enforcement

## 📊 Analytics

The app includes optional analytics tracking:

- **User Behavior**: Screen views, button clicks
- **Performance**: App startup time, crash reports
- **Business Metrics**: Conversions, user engagement

## 🔔 Notifications

Push notifications for:

- **Order Updates**: Status changes, delivery updates
- **Price Alerts**: Price changes for wishlist items
- **Promotional**: Special offers and announcements

## 🌍 Internationalization

Supported languages:

- English (en_US)
- Spanish (es_ES)
- French (fr_FR)
- German (de_DE)
- Russian (ru_RU)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

### Code Style

- Follow Dart style guide
- Use meaningful variable names
- Add comments for complex logic
- Write unit tests for business logic

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Rupa (Andrey Isakin)** - Technical vision and architecture
- **Sudarshan (Sean)** - Business logic and user experience
- **Alexander (Urabi-Nativemind)** - Business ideas and market strategy
- **Avadhut Maharaj** - iOS testing and validation
- **Hrishikesh Maharaj** - Android testing and validation
- **Vijay Raman** - Bug fixes and code quality

## 📞 Support

For support and questions:

- **Email**: support@taxlien.online
- **Documentation**: [REFACTORING_DOCUMENTATION.md](REFACTORING_DOCUMENTATION.md)
- **Issues**: [GitHub Issues](https://github.com/your-username/taxlien-mobile-app/issues)

## 🔄 Changelog

### Version 2.0.0 (Current)
- Complete UI/UX refactoring
- Magento API integration
- Modern state management with Riverpod
- GoRouter navigation
- Dark/Light theme support
- Enhanced security features
- Performance optimizations

### Version 1.0.5 (Previous)
- Basic tax lien functionality
- Simple UI
- Local data storage

## 🎯 Roadmap

### Upcoming Features
- [ ] Advanced search and filtering
- [ ] Real-time bidding
- [ ] Portfolio management
- [ ] Advanced analytics dashboard
- [ ] Social features
- [ ] Multi-currency support
- [ ] Advanced notifications
- [ ] Offline-first architecture

### Long-term Goals
- [ ] AI-powered investment recommendations
- [ ] Blockchain integration
- [ ] Advanced reporting tools
- [ ] White-label solution
- [ ] Enterprise features

---

**Built with ❤️ by the TaxLien.online team**

