import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grupolaranja20212/pages/main_page.dart';
import 'package:grupolaranja20212/pages/welcome_page.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  // usando tutorial do https://www.youtube.com/watch?v=1k-gITZA9CI pra configurar google auth
  WidgetsFlutterBinding.ensureInitialized();

  // INICIALIZA O APP, DEFININDO VAR DE APP ID PRO ONE SIGNAL E DEFININDO PAGINA INICIAL DO APP VERIFICANDO SE USER TA LOGADO OU N
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.orange,
    systemNavigationBarColor: Colors.purple[200],
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Remove this method to stop OneSignal Debugging
  // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("6e064919-a3ca-4f23-a88a-275b5594d4e8");

  // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    // print("Accepted permission: $accepted");
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is received in foreground
    // Display Notification, pass null param for not displaying the notification
    event.complete(event.notification);
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    // Will be called whenever the permission changes
    // (ie. user taps Allow on the permission prompt in iOS)
  });

  OneSignal.shared
      .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    // Will be called whenever the subscription changes
    // (ie. user gets registered with OneSignal and gets a user ID)
  });

  OneSignal.shared.setEmailSubscriptionObserver(
      (OSEmailSubscriptionStateChanges emailChanges) {
    // Will be called whenever then user's email subscription changes
    // (ie. OneSignal.setEmail(email) is called and the user gets registered
  });

  // Set default home.
  Widget _defaultHome = const WelcomePage();

  if (FirebaseAuth.instance.currentUser != null) {
    _defaultHome = const MainPage();
  }

  // Run app!
  runApp(MaterialApp(
    title: 'JOBer',
    home: _defaultHome,
  ));
}
