import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_trash_mobile/api/notification_api.dart';
import 'package:smart_trash_mobile/data/bloc/login/login_bloc.dart';
import 'package:smart_trash_mobile/data/bloc/trash/trash_bloc.dart';
import 'package:smart_trash_mobile/data/bloc/trash_history/trash_history_bloc.dart';
import 'package:smart_trash_mobile/data/bloc/user/user_bloc.dart';
import 'package:smart_trash_mobile/data/bloc/websocket/websocket_bloc.dart';
import 'package:smart_trash_mobile/data/repositories/login_repository.dart';
import 'package:smart_trash_mobile/data/repositories/trash_repository.dart';
import 'package:smart_trash_mobile/data/repositories/user_repository.dart';
import 'package:smart_trash_mobile/presentation/screens/garbage_monitor.dart';
import 'package:smart_trash_mobile/presentation/screens/garbage_monitor_detail.dart';
import 'package:smart_trash_mobile/presentation/screens/home.dart';
import 'package:smart_trash_mobile/presentation/screens/login.dart';
import 'package:smart_trash_mobile/presentation/screens/report.dart';
import 'package:smart_trash_mobile/presentation/screens/user_setting.dart';
import 'package:smart_trash_mobile/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trash_mobile/utils/middlewares/token_middleware.dart';
import 'package:smart_trash_mobile/utils/services/notification_service.dart';
import 'package:smart_trash_mobile/utils/storage/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> _firebaseMessagingForegroundHandler(RemoteMessage message) async {
  print("Title fg: ${message.notification?.title}");
  print("Body fg: ${message.notification?.body}");
  print("Payload fg: ${message.data}");

  if (message.notification != null) {
    print("hahaha");
    NotificationApi.display(message);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCOteaThHTmk2mgBD9kuxDiIMB93O4vlZI",
          appId: "1:444507236833:ios:e22a2387762e33c41b8aa0",
          messagingSenderId: "444507236833",
          projectId: "belajar-4c0e4"));

  FirebaseMessaging.onMessageOpenedApp
      .listen(_firebaseMessagingBackgroundHandler);

  // await FirebaseMessagingService().initNotifications();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);

  await dotenv.load();

  final prefs = SharedPreferencesService();
  await prefs.init();

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => LoginBloc(LoginRepository()),
    ),
    BlocProvider(
      create: (context) => UserBloc(UserRepository()),
    ),
    BlocProvider(
      create: (context) => WebsocketBloc(),
    ),
    BlocProvider(
      create: (context) => TrashBloc(TrashRepository()),
    ),
    BlocProvider(
      create: (context) => TrashHistoryBloc(TrashRepository()),
    )
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NotificationServices notificationServices = NotificationServices();

  void _handleMessage(RemoteMessage message) {
    print("data: $message.data");
    if (message.data["type"] == 'monitoring_full') {
      Navigator.pushNamed(context, Routes.garbageMonitor);
    }
    if (message.data["type"] == 'monitoring_almost_full') {
      Navigator.pushNamed(context, Routes.garbageMonitor);
    }
  }

  @override
  void initState() {
    super.initState();
    NotificationApi.initialize();
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    // FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
  }

  @override
  Widget build(BuildContext context) {
    NotificationApi notif = NotificationApi();

    notif.firebaseInit(context);

    final Map<String, WidgetBuilder> protectedRoutes = {
      Routes.home: (context) => const HomeScreen(),
      Routes.userSetting: (context) => const UserSettingScreen(),
      Routes.garbageMonitor: (context) => GarbageMonitorScreen(),
      Routes.report: (context) => const ReportScreen(),
      Routes.garbageMonitorDetail: (context) => GarbageMonitorDetail(),
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.login,
      routes: protectedRoutes,
      onGenerateRoute: (setting) {
        if (protectedRoutes.containsKey(setting.name) &&
            checkTokenMiddleware()) {
          final WidgetBuilder? builder = protectedRoutes[setting.name];

          return MaterialPageRoute(builder: (context) => builder!(context));
        }

        return MaterialPageRoute(builder: (context) => const LoginScreen());
      },
    );
  }
}
