# Duare iOS App Store Handoff

This is an update to the existing Duare App Store app after rebranding. Apple does not accept Android `.aab` files. The Mac must build and upload an iOS `.ipa` from this Flutter source project.

## Before using the Mac

- In App Store Connect, open the existing app record. Do not create a new app.
- Confirm its Bundle ID is exactly `net.duare.duare`. The archived 2023 provisioning profiles identify the existing App ID as `Z5UYGP25LB.net.duare.duare`; never create a replacement App Store record with a different identifier.
- Confirm the Apple Developer Program membership and agreements are active.
- Invite the Mac owner as Developer or App Manager in App Store Connect instead of sharing the Account Holder password. Remove access after publishing if it is no longer needed.
- Find the last uploaded iOS version and build number. The next upload must use a unique, higher build number.

## Mac requirements

- macOS supported by Xcode 26 or later.
- Xcode 26 or later with command-line tools installed.
- Flutter 3.44 or a compatible newer stable version.
- An iPhone for testing OTP login, location, image selection, payments, account deletion, and push notifications.

Apple currently requires iOS uploads to be built with Xcode 26 or later: <https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/>

## First setup on the Mac

Copy the complete repository to the Mac, then run:

```bash
cd "apps/user"
flutter doctor -v
flutter clean
flutter pub get
flutter build ios --config-only
open ios/Runner.xcworkspace
```

Flutter may migrate iOS package integration automatically on the first Mac build. Commit or preserve any generated iOS project changes before creating the final archive.

In Xcode, select the `Runner` target and verify:

- **Display name:** `Duare`
- **Bundle Identifier:** `net.duare.duare`
- **Signing:** Automatically manage signing is enabled and the correct Apple team is selected.
- **Deployment target:** iOS 15.0 or later (required by the current Xcode 26 toolchain).
- **Push Notifications:** Capability is present.
- **Background Modes:** Remote notifications is enabled.
- **App icon:** The 1024×1024 marketing icon shows the rebranded Duare icon and has no transparency.

## Firebase push notifications

The project includes push entitlements and remote-notification background mode, but Apple credentials cannot be completed from Windows.

1. In Apple Developer, create or reuse an APNs authentication key with Apple Push Notifications enabled.
2. In Firebase Console, open or register the Duare iOS app with Bundle ID `net.duare.duare`.
3. Regenerate the iOS Firebase configuration from that exact Firebase app (for example, run `flutterfire configure --platforms=ios --ios-bundle-id=net.duare.duare`) and verify `firebase_options.dart` keeps the same Bundle ID. Do not reuse an iOS Firebase app registered to `com.duare.duareUser`.
4. Under Project Settings → Cloud Messaging, upload the APNs `.p8` key and enter its Key ID and Team ID.
5. Build to a real iPhone, allow notifications, and send a Firebase test notification.

Never add the `.p8` private key to this repository.

## Archived signing files

The folder `duare ios cer/duare ios cer/` proves the historical Team ID and Bundle ID, but it cannot sign this release:

- All four `.cer` files expired on August 18, 2024.
- Both provisioning profiles expired on August 18, 2024.
- The profiles target `net.duare.duare` and Team ID `Z5UYGP25LB`.
- `Certificates.p12` may contain an old private key, but its associated certificate is expired.

Use Xcode automatic signing with the current Apple team to create a new Apple Distribution certificate and App Store provisioning profile. Do not send the old `.p12`, its password, or new signing keys to anyone who does not need signing access.

## Build the App Store file

Use the next public version and a build number higher than every previous iOS upload. For example only, if `2.4.4` and build `27` are unused on iOS:

```bash
flutter build ipa --release --build-name 2.4.4 --build-number 27
```

The output is under `build/ios/ipa/`. Upload the `.ipa` with Apple Transporter, or open the generated `.xcarchive` in Xcode Organizer and choose **Distribute App**. Flutter's official instructions are at <https://docs.flutter.dev/deployment/ios>.

Do not send Apple the Android `.aab`; it is only for Google Play.

## App Store Connect update checklist

- Create the next version under the existing app record and select the uploaded build.
- Update app name, subtitle, description, keywords, promotional text, and rebranding references.
- Upload current screenshots. This target supports iPhone and iPad, so provide every screenshot set App Store Connect requests.
- Set the privacy policy URL to `https://duare.net/privacy-policy` and use a working support URL owned by Duare.
- Complete the current age-rating questionnaire; an unrated app cannot be published.
- Review App Privacy answers for all data collected by Duare and third parties, including phone number, name, delivery address, precise location, photos, order/payment data, device identifiers, Firebase, and Facebook analytics.
- Because Facebook analytics is present and ATT was intentionally not added, confirm with the SDK/data owner whether any data is used for cross-app tracking. If yes, ATT permission and the tracking privacy declaration are required before submission.
- Confirm export compliance. `Info.plist` declares that the app does not use non-exempt encryption; change this if the app uses encryption beyond standard exempt HTTPS/TLS.
- Add App Review notes with a working Bangladeshi phone/OTP test path, delivery area instructions, and any payment testing instructions.
- Test account deletion at Account → Account & Privacy → Delete account. It deletes the customer profile immediately while historical order/payment records may be retained where legally required.

Apple requires an in-app account-deletion path for apps that create accounts: <https://developer.apple.com/support/offering-account-deletion-in-your-app/>. Apple also requires the privacy label to include relevant third-party SDK collection: <https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy>.

## Release sequence

1. Upload the signed `.ipa`.
2. Wait for App Store Connect processing and resolve every warning.
3. Test the processed build through TestFlight on a real iPhone and iPad if available.
4. Attach the build to the new version, complete compliance questions, and submit for review.
5. After approval, release manually or with the chosen phased/automatic release option.
