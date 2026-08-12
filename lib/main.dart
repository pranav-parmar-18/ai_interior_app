import 'package:ai_interior/firebase_options.dart';
import 'package:ai_interior/routes/app_routes.dart';
import 'package:ai_interior/utils/bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ai_interior/l10n/generated/app_localizations.dart';
import 'package:ai_interior/bloc/locale/locale_cubit.dart';

import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();
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
    LiquidGlassWidgets.wrap(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return BlocProvider(
      create: (_) => LocaleCubit(),
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            title: 'AI Interior',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Georgia',
            ),
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
              Locale('it'),
              Locale('fr'),
              Locale('ar'),
              Locale('tr'),
              Locale('ru'),
              Locale('pt'),
              Locale('de'),
              Locale('fil'),
              Locale('ja'),
              Locale('ko'),
              Locale('zh'),
              Locale('nl'),
            ],
            onGenerateRoute: (settings) => appRouter.onGenerateRoute(settings),
          );
        },
      ),
    );
  }
}

