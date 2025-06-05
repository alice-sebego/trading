import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'Widgets/dashboard.dart';
import 'Widgets/auth/login_page.dart';
import 'Widgets/auth/register_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Trading',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 9, 126, 126),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 9, 126, 126),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 9, 126, 126),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 28, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      home: const AuthWrapper(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/dashboard':
            return _slideRoute(const DashboardPage());
          case '/register':
            return _slideRoute(const RegisterPage());
          default:
            return null;
        }
      },
    );
  }
}

/// Widget pour rediriger automatiquement selon l’état de connexion
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return const DashboardPage(); // Redirection après connexion
        }
        return const LoginPage(); // Sinon page de connexion
      },
    );
  }
}

/// Transition Slide
PageRouteBuilder _slideRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(begin: const Offset(0, 1), end: Offset.zero)
          .chain(CurveTween(curve: Curves.ease));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
