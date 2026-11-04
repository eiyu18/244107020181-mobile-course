# Flutter Week 6 - Authentication, Security and FCM

This project (`campus_notify`) demonstrates a mock login with secure token storage and automatic token refresh,
Firebase Cloud Messaging (FCM) with the token lifecycle, and notification handling in the foreground,
background, and terminated app states with GoRouter deep links.

## Project Stages

### 1. Lab 1 - Login, secure storage, and token refresh

![Login page](./screenshots/Lab1_Login.png)
![Home after login](./screenshots/Lab1_Home.png)

### 2. Lab 2 - FCM, permission, and token lifecycle

![Truncated token on the Debug page](./screenshots/Lab2_Token.png)
![Token after clearing app data (onTokenRefresh)](./screenshots/Lab2_TokenRefresh.png)
![Firebase Console test](./screenshots/fcm-console-test.png)

### 3. Lab 3 - Payloads, three app states, clicks, and topics

Test matrix (same payload: `route = /announcement/3`, `id = 3`):

![Foreground banner](./screenshots/Lab3_Foreground.png)
![Background banner](./screenshots/Lab3_Background.png)
![Terminated launch](./screenshots/Lab3_Terminated.png)
![Deep link destination](./screenshots/Lab3_DeepLink.png)
![Topic campaign](./screenshots/Lab3_Topic.png)

## AI Verification Checklist

* **Is the background handler a top-level function with `@pragma('vm:entry-point')`?**
Yes. `firebaseMessagingBackgroundHandler` is declared at the top level of `push_service.dart` with the annotation and is registered through `registerBackgroundHandler()`. It does not use `BuildContext` or Riverpod.

* **Does `onTokenRefresh` actually send the new token to the backend, not just print it?**
In code, yes. The same `onToken` callback is used for both the first `getToken()` and `onTokenRefresh`, and it posts to `/devices`. Because the backend URL is a mock, the request fails and the result is written to the Debug log. *(Add your wipe-data / reinstall result here.)*

* **Does foreground use a manual local notification?**
Yes. `listenForeground` calls `flutter_local_notifications` from `onMessage`, with the route as the payload.

* **Do clicks from all three states land on the correct route?**
See the test matrix above.

* **Are tokens and secrets free from hardcoding and full logging?**
Tokens are stored only in `flutter_secure_storage`. The UI and logs use `truncateToken`. The Debug page has a "Copy full token" button that only writes to the clipboard so a test message can be sent from the Firebase Console. The full token is never logged or shown on screen.

* **Do `flutter analyze` and `flutter test` pass?**

### Modifications to AI-Generated Code

After reviewing the AI output, the following fixes were needed to make the project build and behave correctly:

- **`flutter_local_notifications` API change:** the installed version requires named arguments, so `initialize(settings: ...)` and `show(id:, title:, body:, notificationDetails:, payload:)` were used instead of the positional form.
- **Core library desugaring:** enabled `isCoreLibraryDesugaringEnabled` and added the `desugar_jdk_libs` dependency in `android/app/build.gradle.kts`.
- **Duplicate Gradle plugin:** `com.google.gms.google-services` was declared twice in the app module, which broke the build. It is now declared once there and once (with `apply false`) in `settings.gradle.kts`.
- **Android 13+ permission:** added `POST_NOTIFICATIONS` to `AndroidManifest.xml`.
- **Router refresh:** added a `refreshListenable` so the login guard re-runs after login and logout.

## Refactoring and Testing

* **Moved route strings into `lib/routes.dart`** (`AppRoutes`) so GoRouter and FCM deep links share the same constants.
* **Extracted `routeFromMessage`** as a pure function so route parsing can be tested without Firebase.
* **Moved Dio error mapping into `lib/data/api_errors.dart`** (`friendlyError`) so the UI only receives user-friendly messages.
* **Tests** in `test/auth_push_test.dart` cover route parsing (empty, slash-less, and full routes), the data payload id, login status from the token, and forcing re-login after a failed refresh.

## Reflection

* **Why must refresh tokens never live in SharedPreferences? What is the risk if one leaks?**
  SharedPreferences is stored as plain, unencrypted data, so anyone who can read the app data (a rooted device, a backup, malware) can read the token. A leaked refresh token lets an attacker keep requesting new access tokens for as long as it stays valid, so it is effectively a long-lived login. `flutter_secure_storage` keeps it in the Android Keystore / iOS Keychain instead.

* **What breaks if `onTokenRefresh` is ignored for a whole semester?**
  The token can change after a reinstall, a data wipe, or a security rotation. The backend would keep sending messages to the old token, so users would silently stop receiving notifications while nothing in the app looks broken.

* **When do you use a topic vs a device token? Give one campus message example for each.**
  A topic is for broadcasts to a group, for example "Schedule changed" for all students on `campus-announcement`. A device token is for personal messages, for example a grade or a bill reminder, so only that one user receives it.

* **Which part of the AI draft did you reject or fix, and why?**
  I fixed the `flutter_local_notifications` calls to match the installed API, enabled core library desugaring, removed a duplicated Gradle plugin, added the Android 13+ notification permission, and added a router refresh so the login guard reacts to auth changes. I also moved route strings and error mapping into their own files so they can be shared and tested.
