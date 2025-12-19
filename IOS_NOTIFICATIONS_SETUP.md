# iOS Push Notifications Configuration Guide

This document outlines the iOS push notification configuration for the Self Actualization app.

## ✅ Configuration Complete

All necessary iOS notification configurations have been set up:

### 1. **Info.plist Configuration**
- ✅ `UIBackgroundModes` - Added `remote-notification` and `fetch` modes
- ✅ This allows the app to receive notifications in the background

### 2. **AppDelegate.swift Configuration**
- ✅ Firebase Cloud Messaging (FCM) integration
- ✅ APNs (Apple Push Notification service) token registration
- ✅ Notification permission request
- ✅ Foreground notification handling
- ✅ Notification tap/interaction handling
- ✅ FCM token management

### 3. **Entitlements File**
- ✅ `Runner.entitlements` configured with `aps-environment`
- ⚠️ Currently set to `development` (for testing)
- 📝 **Important**: Change to `production` before App Store release

## Features Configured

### Background Notifications
- App can receive notifications when in background
- App can process notifications when closed

### Foreground Notifications
- Notifications display even when app is active
- Uses iOS 14+ banner style when available

### Notification Interaction
- Handles notification taps
- Can navigate to specific screens based on notification data
- Custom notification handling logic ready

### Firebase Cloud Messaging
- Automatic APNs token registration
- FCM token generation and management
- Token available via `NotificationCenter` with name `"FCMToken"`

## Testing Notifications

### Development Mode
1. Ensure `Runner.entitlements` has `aps-environment` set to `development`
2. Use Firebase Console to send test notifications
3. Test on physical device (simulator doesn't support push notifications)

### Production Mode
1. Change `Runner.entitlements` `aps-environment` to `production`
2. Build with production provisioning profile
3. Test with production APNs certificates

## APNs Certificate Setup

### Required Steps:
1. **Generate APNs Key in Apple Developer Portal:**
   - Go to https://developer.apple.com/account/resources/authkeys/list
   - Create a new key with "Apple Push Notifications service (APNs)" enabled
   - Download the `.p8` key file

2. **Upload to Firebase Console:**
   - Go to Firebase Console → Project Settings → Cloud Messaging
   - Upload the APNs Authentication Key (`.p8` file)
   - Enter your Team ID and Key ID

3. **Alternative: APNs Certificate (Legacy)**
   - Generate APNs certificate in Apple Developer Portal
   - Upload to Firebase Console

## Notification Payload Format

### Standard FCM Payload:
```json
{
  "to": "FCM_TOKEN",
  "notification": {
    "title": "Notification Title",
    "body": "Notification body text",
    "sound": "default"
  },
  "data": {
    "custom_key": "custom_value"
  }
}
```

### Data-Only Payload (for background):
```json
{
  "to": "FCM_TOKEN",
  "data": {
    "key1": "value1",
    "key2": "value2"
  },
  "content_available": true
}
```

## Code Implementation

### Receiving FCM Token in Flutter:
```dart
// Listen for FCM token
FirebaseMessaging.instance.getToken().then((token) {
  print("FCM Token: $token");
  // Send token to your backend
});

// Listen for token refresh
FirebaseMessaging.instance.onTokenRefresh.listen((token) {
  print("New FCM Token: $token");
  // Update token in your backend
});
```

### Handling Notification Taps:
The AppDelegate already handles notification taps. You can extend the `didReceive` method to navigate to specific screens based on notification data.

## Troubleshooting

### Notifications Not Received:
1. ✅ Check APNs certificate/key is uploaded to Firebase
2. ✅ Verify `aps-environment` matches your build (development/production)
3. ✅ Ensure device has internet connection
4. ✅ Check notification permissions are granted
5. ✅ Verify FCM token is valid

### Notifications Not Showing in Foreground:
- ✅ Already configured - notifications will show as banners when app is active

### Token Not Generated:
- ✅ Check Firebase initialization in AppDelegate
- ✅ Verify GoogleService-Info.plist is in the bundle
- ✅ Check device logs for errors

## Production Checklist

Before releasing to App Store:
- [ ] Change `aps-environment` to `production` in `Runner.entitlements`
- [ ] Upload production APNs key/certificate to Firebase
- [ ] Test notifications with production build
- [ ] Verify notification handling works correctly
- [ ] Test on multiple iOS versions (iOS 13+)

## Current Configuration Status

✅ **All notification configurations are complete and ready to use!**

The app is configured to:
- Receive push notifications from Firebase
- Display notifications in foreground and background
- Handle notification interactions
- Manage FCM tokens automatically

