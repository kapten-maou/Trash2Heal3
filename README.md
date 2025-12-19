# TRASH2HEAL - Waste Management & Recycling Rewards App

A comprehensive Flutter mobile application for waste management with a rewards system, built with Firebase backend.

## 📋 Features

### User Features
- **Authentication**: Email/password registration and login
- **Pickup Scheduling**: Schedule waste pickup with slot management
- **Points System**: Earn points for recycling, redeem for coupons or cash
- **Membership Plans**: Premium membership with benefits
- **Events & Coupons**: Redeem products with earned coupons
- **Notifications**: Real-time updates via FCM
- **Chat**: In-app messaging with couriers
- **Profile Management**: Address, payment methods, wallet

### Courier Features
- **Task Management**: View assigned pickup tasks
- **Live Tracking**: Real-time location updates
- **Proof Upload**: Upload photos and actual weight collected
- **Status Updates**: Multi-step status progression

### Admin Features (via Firebase Console + Cloud Functions)
- **Slot Management**: Create and manage pickup slots
- **Rate Configuration**: Set point rates per waste category
- **Event Management**: Create events and items
- **Courier Assignment**: Manual or automatic assignment
- **Transaction Monitoring**: View all payments and redeems

## 🏗️ Architecture

### Frontend (Flutter)
```
lib/
├── core/
│   ├── config/          # App configuration
│   ├── theme/           # Material 3 theme
│   └── constants/       # Constants & enums
├── router/              # GoRouter navigation
├── common/
│   ├── widgets/         # Reusable widgets
│   └── services/        # Firebase, Maps, FCM
├── data/
│   ├── models/          # Freezed data models
│   └── repositories/    # Firestore repositories
└── features/
    ├── auth/            # Login & Register
    ├── home/            # Dashboard
    ├── pickup/          # Pickup flow
    ├── points/          # Points & Redeem
    ├── events/          # Events & Coupons
    ├── member/          # Membership
    ├── profile/         # User profile
    ├── notify_chat/     # Notifications & Chat
    └── courier/         # Courier features
```

### Backend (Firebase)
```
server/
├── firestore.rules      # Firestore security rules
├── storage.rules        # Storage security rules
└── functions/
    ├── src/
    │   ├── pickup/      # Pickup management
    │   ├── points/      # Points & rewards
    │   ├── payments/    # Payment integration
    │   ├── events/      # Event management
    │   ├── notifications/ # FCM & triggers
    │   ├── chat/        # Chat functions
    │   ├── membership/  # Membership activation
    │   └── utils/       # Helper functions
    └── package.json
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x
- Dart SDK
- Firebase CLI
- Node.js & npm (for Cloud Functions)
- Android Studio / Xcode

### 1. Clone Repository
```bash
git clone https://github.com/yourorg/trash2heal.git
cd trash2heal
```

### 2. Setup Flutter App

```bash
cd app

# Install dependencies
flutter pub get

# Generate code (Freezed, Riverpod)
flutter pub run build_runner build --delete-conflicting-outputs

# Copy environment file
cp .env.example .env
# Edit .env with your Firebase credentials
```

### 3. Setup Firebase

#### a. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create new project: `trash2heal`
3. Enable Authentication (Email/Password)
4. Create Firestore Database
5. Create Storage bucket
6. Enable Cloud Functions
7. Enable Realtime Database (for live tracking)
8. Enable Analytics & Crashlytics

#### b. Add Firebase to Flutter
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

This will create `lib/firebase_options.dart`

#### c. Setup Cloud Functions
```bash
cd server/functions

# Install dependencies
npm install

# Login to Firebase
firebase login

# Deploy functions
firebase deploy --only functions

# Deploy rules
firebase deploy --only firestore:rules,storage:rules
```

### 4. Configure Google Maps

#### Android
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

#### iOS
Edit `ios/Runner/AppDelegate.swift`:
```swift
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```

### 5. Run the App

```bash
# Run on Android
flutter run -d android

# Run on iOS
flutter run -d ios

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release
```

## 🔧 Configuration

### Environment Variables (.env)
```env
ENV=development
FIREBASE_PROJECT_ID=trash2heal-xxxxx
FIREBASE_API_KEY=AIzaSy...
PAYMENT_API_KEY=your_payment_api_key
PAYMENT_WEBHOOK_SECRET=your_webhook_secret
USE_MOCK_PAYMENT=true
GOOGLE_MAPS_API_KEY=AIzaSy...
```

### Business Rules (lib/core/config/app_config.dart)
- `POINTS_TO_COUPON_RATIO`: Points needed for 1 coupon (default: 1000)
- `MIN_CASHOUT_AMOUNT`: Minimum cashout amount (default: 50000)
- `PIN_LENGTH`: PIN length for cashout (default: 6)
- `GEOFENCE_THRESHOLD_METERS`: Distance threshold for pickup (default: 100m)

## 📊 Data Model

### Collections

**users**
- uid, name, username, email, phone, dob
- roles: {user, courier, admin}
- member: {planId, status, startedAt, expiresAt}
- points: {balance, couponBalance}

**pickup_requests**
- uid, addressId, date, slotId
- quantities: {plastic, glass, can, cardboard, fabric, ceramicStone}
- estPoints, estWeightKg, status

**pickup_tasks**
- requestId, courierId, status
- proof: {photos[], weightKg}
- otp

**point_ledger**
- uid, delta, reason, refId, ts

**coupons**
- uid, eventId, code, amount, status

**events** & **event_items**
- Event catalog for coupon redemption

**notifications**
- uid, type, title, body, deeplink, isRead

**chats/{threadId}/messages**
- fromUid, toUid, text, ts, status

## 🔐 Security

### Authentication
- Firebase Authentication (Email/Password)
- Email verification
- Password reset

### Authorization
- Firestore Security Rules enforce:
  - Users can only access their own data
  - Couriers can only access assigned tasks
  - Sensitive operations (points, payments) via Cloud Functions only

### Data Protection
- Points updates only via Cloud Functions
- Payment PIN required for cashout
- Idempotency keys for financial transactions
- Geofence validation for pickups

## 💳 Payment Integration

The app supports integration with Midtrans or Xendit for:
- **Membership Payment**: Virtual Account, QRIS
- **Cashout/Disbursement**: Transfer to bank or e-wallet

### Mock Mode
Set `USE_MOCK_PAYMENT=true` in `.env` for testing without real payment gateway.

### Production Setup
1. Get API keys from Midtrans/Xendit
2. Update `.env` with production credentials
3. Implement webhook handlers in Cloud Functions
4. Verify signature validation

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Cloud Functions Tests
```bash
cd server/functions
npm test
```

## 🌱 Seed Data

Run seed script to populate initial data:

```bash
# Via Firebase Console or Cloud Functions
node server/seed/seed_data.js
```

This creates:
- Pickup rates for all categories
- Sample pickup slots
- Sample membership plans
- 1 sample event with 3 items

## 📱 Deep Linking

The app supports deep linking for notifications:
```
trash2heal://app/pickup/{requestId}
trash2heal://app/points
trash2heal://app/events/{eventId}
trash2heal://app/member
```

## 🔔 Push Notifications

FCM topics:
- `all_users`: All registered users
- `couriers_only`: Only courier users

Notification types:
- Pickup updates
- Points earned
- Payment confirmation
- Membership activated
- Chat messages

## 📈 Analytics

Firebase Analytics events:
- `sign_up`, `login`, `logout`
- `pickup_requested`, `pickup_completed`
- `points_redeemed`, `cashout_requested`
- `membership_purchased`

## 🐛 Troubleshooting

### Build Issues
```bash
# Clean build
flutter clean
flutter pub get

# Rebuild generated code
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Firebase Connection Issues
- Check `google-services.json` (Android) is in correct location
- Check `GoogleService-Info.plist` (iOS) is added to Xcode
- Verify package name matches Firebase project

### Cloud Functions Deployment
```bash
# Check logs
firebase functions:log

# Deploy specific function
firebase deploy --only functions:reserveSlot
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

## 👥 Team

- **Project Lead**: [Your Name]
- **Frontend**: Flutter Team
- **Backend**: Firebase Team
- **Design**: UI/UX Team

## 📞 Support

For support, email support@trash2heal.com or join our Slack channel.

---

**Made with 💚 for a sustainable future**