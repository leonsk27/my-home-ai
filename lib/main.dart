import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_home/config/constants.dart';
import 'package:my_home/config/theme.dart';
import 'package:my_home/screens/homeScreen.dart';
import 'package:my_home/screens/loginScreen.dart';
import 'package:my_home/screens/registerScreen.dart';
import 'package:my_home/services/storageService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final StorageService storage = StorageService();
  final token = await storage.getToken();
  late bool isAuth;
  if (token != null) {
    bool isExpired = JwtDecoder.isExpired(token);
    if (!isExpired) {
      isAuth = true;
    } else {
      await storage.deleteAll();
      isAuth = false;
    }
  } else {
    isAuth = false;
  }

  runApp(MyApp(initialRoute: isAuth ? "/home" : "/login"));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager().themeNotifier,
      builder: (_, currentMode, child) {
        return MaterialApp(
          title: 'Predicción Inmobiliaria',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          initialRoute: initialRoute,
          routes: {
            "/home": (_) => HomeScreen(),
            "/login": (_) => LoginScreen(),
            "/register": (_) => RegisterScreen(),
          },
          navigatorKey: navigatorKey,
        );
      },
    );
  }
}
