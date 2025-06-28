# Ad Integration Documentation

## Overview
This Flutter Todo app has been integrated with Google AdManager to display three types of ads:
1. **Reward Ads** - For task completion incentives
2. **Interstitial Ads** - For task editing and saving
3. **Banner Ads** - Display ads on the home screen

## Implementation Details

### 1. Dependencies Added
```yaml
google_mobile_ads: ^4.0.0
```

### 2. Ad Service Architecture
- **File**: `lib/core/services/ad_service.dart`
- **Purpose**: Centralized ad management service using GetX
- **Features**:
  - Automatic ad loading and caching
  - Frequency control to prevent ad spam
  - Error handling and fallback mechanisms
  - Session-based ad limits

### 3. Ad Configuration
- **File**: `lib/core/constants/ad_config.dart`
- **Purpose**: Centralized configuration for ad unit IDs and display settings
- **Configurable Options**:
  - Ad unit IDs (test and production)
  - Maximum ads per session
  - Minimum time between ads
  - Feature toggles for different ad types

### 4. Ad Integration Points

#### Home Screen (`lib/modules/home/presentation/home_screen.dart`)
- **Banner Ad**: Displayed at the bottom of the task list
- **Reward Ad**: Triggered when user completes a task (checkmark button)
- **Interstitial Ad**: Triggered when user taps to edit a task

#### Task Form Screen (`lib/modules/home/presentation/task_form_screen.dart`)
- **Interstitial Ad**: Triggered after successfully saving/updating a task

### 5. Ad Types Implementation

#### Reward Ads
- **Trigger**: Task completion button
- **Reward**: User gets a success message and satisfaction
- **Frequency**: Limited to 3 per session with 2-minute intervals
- **Fallback**: Graceful handling when ads are not available

#### Interstitial Ads
- **Triggers**: 
  - Before editing a task
  - After saving/updating a task
- **Frequency**: Limited to 5 per session with 2-minute intervals
- **User Experience**: Non-intrusive timing to maintain app flow

#### Banner Ads
- **Location**: Bottom of home screen
- **Size**: Standard banner (320x50)
- **Loading**: Automatic loading with error handling

### 6. Ad Unit IDs

#### Test IDs (Currently Used)
```dart
static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
```

#### Production IDs (To Be Updated)
Replace the test IDs in `lib/core/constants/ad_config.dart` with your actual AdManager IDs:
```dart
// Uncomment and replace with your actual IDs
// static const String rewardedAdUnitId = 'your-rewarded-ad-unit-id';
// static const String interstitialAdUnitId = 'your-interstitial-ad-unit-id';
// static const String bannerAdUnitId = 'your-banner-ad-unit-id';
```

### 7. Ad Frequency Control

#### Session Limits
- **Interstitial Ads**: Maximum 5 per session
- **Reward Ads**: Maximum 3 per session
- **Time Between Ads**: Minimum 2 minutes between any ad type

#### User Experience Considerations
- Ads are loaded in the background to minimize loading times
- Graceful fallbacks when ads fail to load
- Non-blocking ad display to maintain app functionality

### 8. Setup Instructions

#### 1. Update Ad Unit IDs
1. Open `lib/core/constants/ad_config.dart`
2. Replace test IDs with your actual AdManager IDs
3. Uncomment production IDs and comment out test IDs

#### 2. Configure Ad Display Settings
In `lib/core/constants/ad_config.dart`, you can:
- Adjust maximum ads per session
- Change minimum time between ads
- Toggle specific ad types on/off

#### 3. Android Configuration
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<application>
    <!-- Add your AdManager app ID -->
    <meta-data
        android:name="com.google.android.gms.ads.APPLICATION_ID"
        android:value="ca-app-pub-3940256099942544~3347511713"/>
</application>
```

#### 4. iOS Configuration
Add to `ios/Runner/Info.plist`:
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string>
```

### 9. Testing

#### Test Mode
- Currently using Google's test ad unit IDs
- Ads will display test content
- Perfect for development and testing

#### Production Mode
- Replace test IDs with actual AdManager IDs
- Ensure proper AdManager account setup
- Test with real ad campaigns

### 10. Best Practices Implemented

1. **User Experience**:
   - Non-intrusive ad placement
   - Graceful error handling
   - Loading states for better UX

2. **Performance**:
   - Background ad loading
   - Efficient ad caching
   - Memory management

3. **Monetization**:
   - Strategic ad placement
   - Frequency control to prevent user fatigue
   - Multiple ad types for better revenue

4. **Maintainability**:
   - Centralized configuration
   - Modular ad service
   - Easy to update and modify

### 11. Troubleshooting

#### Common Issues
1. **Ads not showing**: Check ad unit IDs and network connectivity
2. **Test ads not loading**: Ensure test IDs are correctly configured
3. **Production ads not working**: Verify AdManager account setup and ad unit configuration

#### Debug Information
- Ad loading status is logged to console
- Error messages provide specific failure reasons
- Ad service observables can be monitored for debugging

### 12. Future Enhancements

1. **Advanced Targeting**: Implement user-based ad targeting
2. **A/B Testing**: Add ad placement and frequency testing
3. **Analytics**: Integrate ad performance analytics
4. **Custom Ad Formats**: Add native ad support
5. **Offline Handling**: Improve ad loading during poor connectivity

## Conclusion

The ad integration provides a comprehensive monetization solution while maintaining excellent user experience. The modular design allows for easy customization and future enhancements. Remember to replace test ad unit IDs with your actual AdManager IDs before production deployment. 