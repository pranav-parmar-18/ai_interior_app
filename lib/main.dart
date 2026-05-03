import 'package:ai_interior/firebase_options.dart';
import 'package:ai_interior/routes/app_routes.dart';
import 'package:ai_interior/utils/bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Prevent duplicate initialization
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      Firebase.app();
    }

    print("✅ Firebase initialized successfully.");
  } catch (e, stackTrace) {
    print("❌ Firebase initialization failed: $e");
    print("Stack trace: $stackTrace");
  }

  const DarwinInitializationSettings initializationSettingsDarwin =
  DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher'); // your launcher icon


  const InitializationSettings initializationSettings = InitializationSettings(
    iOS: initializationSettingsDarwin,
    android: initializationSettingsAndroid,

  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel_id', // unique id
            'General Notifications', // channel name
            channelDescription: 'Used for important notifications',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    }
  });


  Bloc.observer = SimpleBlocObserver();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return MaterialApp(
      title: 'AI Interior',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PlayfairDisplay',
      ),
      onGenerateRoute: (settings) => appRouter.onGenerateRoute(settings),
    );
  }
}

