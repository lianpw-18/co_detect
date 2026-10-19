import 'package:flutter/material.dart';
import 'screens/main_nav_screen.dart';
import 'services/user_session.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSession.instance.init();
  runApp(const CoDetectApp());
}

class CoDetectApp extends StatelessWidget {
  const CoDetectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserSession.instance,
      builder: (context, _) {
        final session = UserSession.instance;
        return MaterialApp(
          title: 'Co-Detect',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: session.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          builder: (context, child) {
            final double scale = session.isSeniorFriendlyMode ? 1.15 : 1.0;
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(scale),
              ),
              child: child!,
            );
          },
          home: const MainNavScreen(),
        );
      },
    );
  }
}
