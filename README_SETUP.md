# Shaurya TMT - B2B Distributor & Dealer Management Portal

A modern, sleek Flutter mobile application for managing B2B distributor and dealer operations with an intuitive UI/UX design.

## 🎯 Project Overview

Shaurya TMT is a comprehensive B2B portal designed specifically for distributor and dealer management. The app provides features for order management, loyalty rewards, real-time tracking, and seamless communication between distributors and dealers.

### Key Features

#### ✅ Authentication
- **Email/Password Login**: Traditional credential-based authentication
- **OTP Fast Login**: Quick sign-in via one-time password
- **Biometric Unlock**: FaceID/Fingerprint authentication support
- **Password Recovery**: Easy password reset functionality

#### ✅ Home Dashboard
- **Personalized Greeting Card**: Dynamic greeting with live connection status
- **KPI Summary Cards**: Real-time metrics for orders, pending dealers, and inventory
- **Interactive Order Summary**: Collapsible order cards with product breakdowns
- **Quick Action Buttons**: Fast access to create orders, view reports, track shipments
- **Floating Action Button**: One-click access to create new orders

#### ✅ Order Management
- **Order History**: Comprehensive list of all orders with filtering
- **Order Drill-Down**: Detailed order view with product specifications
- **Status Tracking**: Real-time order status (Pending, Confirmed, Shipped, Delivered)
- **Payment Status**: Visual indicators for payment states
- **Retailer Breakdown**: View orders grouped by dealer/retailer
- **Search & Filter**: Quick search and advanced filtering capabilities

#### ✅ Super Coins Loyalty Program
- **Hero Balance Card**: Prominent display of available coins with gradient design
- **Earn Steps Guide**: Interactive step tracker showing how to earn coins
- **Gamified Rewards**: Visual progress indicators and achievement tracking
- **Redeem Options**: Browse and redeem from a catalog of rewards
- **Activity Feed**: Detailed history of earned and redeemed coins with timestamps
- **Tabbed Interface**: Separate views for Earned, Redeem, and Activity history

#### ✅ Modern Navigation
- **Floating Bottom Navigation**: Clean, intuitive navigation bar
- **Screen Transitions**: Smooth navigation between sections
- **Drawer Menu**: Additional options for support and settings
- **Responsive Design**: Adapts to different screen sizes

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point
├── config/
│   ├── theme/
│   │   ├── app_colors.dart           # Color scheme & palette
│   │   ├── app_text_styles.dart      # Typography definitions
│   │   └── app_theme.dart            # Light/Dark theme setup
│   └── constants/
│       └── app_constants.dart         # App-wide constants
├── models/
│   ├── user_model.dart               # User data structure
│   ├── order_model.dart              # Order data structure
│   ├── product_model.dart            # Product data structure
│   └── reward_model.dart             # Reward & coin data structures
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart         # Login page with OTP option
│   │   └── otp_verification_screen.dart  # OTP verification
│   ├── dashboard/
│   │   └── home_dashboard_screen.dart    # Main dashboard
│   ├── orders/
│   │   ├── order_history_screen.dart     # Order list & filtering
│   │   └── order_detail_screen.dart      # Order details (future)
│   ├── rewards/
│   │   └── rewards_loyalty_screen.dart   # Coins & loyalty program
│   ├── profile/
│   │   └── profile_screen.dart           # User profile & settings
│   └── navigation/
│       └── main_navigation_screen.dart   # Bottom tab navigation
├── widgets/
│   ├── common/
│   │   ├── custom_app_bar.dart       # Reusable app bar
│   │   ├── custom_button.dart        # Custom button variants
│   │   ├── custom_card.dart          # Glassmorphism cards
│   │   └── custom_bottom_nav.dart    # Bottom navigation widget
│   ├── dashboard/
│   │   ├── greeting_card.dart        # Personalized greeting
│   │   ├── kpi_card.dart             # KPI metric cards
│   │   └── order_summary_card.dart   # Order preview card
│   ├── rewards/
│   │   ├── balance_card.dart         # Coin balance display (future)
│   │   ├── step_tracker.dart         # Earn steps guide (future)
│   │   └── activity_feed.dart        # Activity timeline (future)
│   └── orders/
│       ├── retailer_card.dart        # Retailer listing (future)
│       └── order_item.dart           # Order list item (future)
├── services/
│   ├── auth_service.dart             # Authentication logic (future)
│   └── order_service.dart            # Order operations (future)
├── providers/
│   ├── auth_provider.dart            # Auth state management
│   ├── order_provider.dart           # Order state management
│   └── reward_provider.dart          # Reward state management
├── utils/
│   ├── validators.dart               # Form validation logic
│   ├── formatters.dart               # Data formatting utilities
│   └── extensions.dart               # Dart extensions
└── assets/
    ├── images/                       # Image assets
    ├── icons/                        # Custom icons
    └── animations/                   # Lottie animations
```

## 🎨 Design System

### Color Palette
- **Primary**: Orange (#FF8C00) - Main brand color
- **Secondary**: Yellow (#FFD700) - Accent color
- **Dark Background**: #0F0F0F
- **Light Background**: #FAFAFA
- **Status Colors**: Green (Success), Red (Warning), Blue (Info), Amber (Pending)

### Typography
- **Display**: Inter Tight - Bold headlines
- **Headings**: Inter Tight - Section titles
- **Body**: Inter - Regular text
- **Numbers**: Inter Tight - Numeric values (coins, units)

### Components
- **Glassmorphism**: Frosted glass effect cards with backdrop blur
- **Border Radius**: 16px (default), 12px (small), 24px (large)
- **Animations**: Smooth transitions, micro-interactions
- **Status Badges**: Color-coded indicators for order status

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.7.0 or higher
- Dart 3.7.0 or higher
- Android Studio / Xcode (for device testing)

### Installation

1. **Clone/Extract the project**
```bash
cd D:\FlutterProjects\distributor
```

2. **Get dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Dependencies

- **provider**: State management
- **get**: Navigation & service locator
- **intl**: Date/time formatting
- **flutter_svg**: SVG support
- **google_fonts**: Custom typography
- **lottie**: Animations
- **shimmer**: Loading states
- **uuid**: ID generation
- **shared_preferences**: Local storage

## 🔧 Development

### Running Tests
```bash
flutter test
```

### Build APK
```bash
flutter build apk
```

### Build iOS
```bash
flutter build ios
```

## 📱 Screens Overview

### 1. Login Screen
- Email/Password authentication
- OTP-based fast login
- Biometric unlock option
- Password recovery link
- Sign-up navigation

### 2. Home Dashboard
- Greeting with connection status
- KPI summary cards (Orders, Pending, Value, Dealers)
- Quick action buttons
- Recent orders list
- FAB for new order creation

### 3. Order History
- Complete order listing
- Filter by status (All, Pending, Confirmed, Shipped, Delivered)
- Search functionality
- Order detail modal
- Date range filtering

### 4. Rewards & Loyalty
- Super Coins balance display
- Earn steps guide with progress
- Three tabs: Earned, Redeem, Activity
- Gamified reward system
- Coin transaction history

### 5. Profile
- User information display
- Account details
- Settings menu
- Help & Support
- Logout option

## 🔐 Mock Data

The app includes mock data for demonstration:
- **Demo Users**: Distributor accounts with pre-filled information
- **Orders**: Sample orders with different statuses
- **Products**: Steel products (ShauryaTMT) with different sizes and grades
- **Rewards**: Pre-loaded coins and reward options

## 🎯 Future Enhancements

- [ ] Real API integration
- [ ] Real-time order notifications
- [ ] Advanced analytics dashboard
- [ ] Invoice generation
- [ ] Payment gateway integration
- [ ] Offline mode support
- [ ] Multi-language support
- [ ] Enhanced search with filters
- [ ] Order forecasting
- [ ] Dealer performance metrics
- [ ] Bulk order management
- [ ] Integration with logistics partners

## 📝 Code Conventions

- **Naming**: camelCase for variables/methods, PascalCase for classes
- **File Organization**: Feature-based folder structure
- **Comments**: Clear documentation for complex logic
- **Error Handling**: Try-catch blocks with user feedback
- **State Management**: Provider pattern for clean architecture

## 🤝 Contributing

For internal development, follow these guidelines:
1. Create a new branch for features
2. Follow the existing code structure
3. Test thoroughly before committing
4. Update documentation as needed

## 📄 License

This project is proprietary and confidential to Shaurya TMT.

## 📞 Support

For technical support or queries, contact the development team.

---

**Version**: 1.0.0  
**Last Updated**: 15-08-2026  
**Status**: Active Development
