# TaxLien Marketplace

Mobile application for investing in tax liens, developed with Flutter.

## Description

TaxLien Marketplace is a modern mobile application that allows investors to buy, track, and manage tax liens. The application provides a convenient interface for searching, analyzing, and investing in tax liens from various auctions.

## Main Features

### 🏠 Lien Marketplace
- View available tax liens
- Search by address, owner, parcel ID
- Filter by state, county, tax amount, interest rate
- Sort by various parameters
- Detailed information about each lien

### 💰 My Investments
- Track purchased liens
- Profitability statistics
- Transaction history
- Favorite liens

### 🔍 Search
- Keyword search
- Search query history
- Quick access to results

### 👤 User Profile
- Registration and authentication
- Profile management
- Balance and finances
- Application settings

## Technical Features

### Architecture
- **Flutter** - cross-platform development
- **MVC Pattern** - architectural pattern
- **Provider** - state management
- **SQLite** - local database
- **HTTP** - network communication

### Services
- `TaxLienService` - work with tax liens
- `AuthService` - authentication and authorization
- `DatabaseService` - local data storage
- `ThemeService` - application theme management
- `LocalizationService` - localization

### Database
- Tax liens table
- Users table
- Transactions table
- Favorites table
- Search history table

## Installation and Setup

### Requirements
- Flutter SDK 3.2.3 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Android SDK / Xcode (for emulators)

### Install Dependencies
```bash
flutter pub get
```

### Run Application
```bash
flutter run
```

### Build Release Version
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── services/                 # Application services
│   ├── auth_service.dart     # Authentication
│   ├── tax_lien_service.dart # Work with liens
│   ├── database_service.dart # Database
│   ├── theme_service.dart    # Application theme
│   └── localization_service.dart # Localization
├── screens/                  # Application screens
│   ├── onboarding_screen.dart    # Onboarding
│   ├── main_navigation_screen.dart # Main navigation
│   ├── marketplace_screen.dart   # Lien marketplace
│   ├── my_investments_screen.dart # My investments
│   ├── search_screen.dart        # Search
│   └── profile_screen.dart       # Profile
├── widgets/                  # Widgets
│   ├── tax_lien_card.dart   # Lien card
│   └── filter_bottom_sheet.dart # Filters
└── theme/                   # Application theme
    └── app_theme_export.dart
```

## API Endpoints

The application uses REST API for server communication:

### Authentication
- `POST /api/auth/register` - registration
- `POST /api/auth/login` - login
- `PUT /api/auth/profile` - update profile
- `PUT /api/auth/password` - change password

### Tax Liens
- `GET /api/tax-liens/available` - available liens
- `GET /api/tax-liens/my-liens` - my liens
- `POST /api/tax-liens/{id}/purchase` - purchase lien
- `GET /api/tax-liens/search` - search liens

## Security

- JWT tokens for authentication
- Password encryption
- Secure data storage
- Input validation

## Localization

The application supports multilingualism:
- English (primary)
- Russian
- Ability to add other languages

## Themes

Light and dark themes are supported:
- Automatic switching
- Manual control
- Save user choice

## License

MIT License - see LICENSE file for details.

## Support

For support or bug reports:
- Create an Issue in the repository
- Refer to documentation
- Contact the development team

## Contributing

We welcome contributions to project development:
1. Fork the repository
2. Create a branch for new feature
3. Make changes
4. Create Pull Request

## Roadmap

### Version 1.1
- [ ] Notifications about new liens
- [ ] Extended analytics
- [ ] Data export
- [ ] Payment system integration

### Version 1.2
- [ ] Web application version
- [ ] API for third-party developers
- [ ] Machine learning for risk analysis
- [ ] Social features

### Version 2.0
- [ ] Blockchain integration
- [ ] NFT tokens for liens
- [ ] Decentralized marketplace
- [ ] International expansion

