import 'package:flutter/material.dart';
import 'Widgets/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Trading',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 9, 126, 126)),
        useMaterial3: true,
      ),
      initialRoute: '/', // initial root
      routes: {
        '/': (context) => const MyHomePage(title: 'Your trading'), // homepage
        '/dashboard': (context) =>
            const DashboardPage(), // dashboard page
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 126, 126),
        iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white, 
          ),
          
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to your trading board',
                style: TextStyle(
                  color: Colors.black, 
                  fontSize: 28.0, 
                )),
            const SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(
                      255, 9, 126, 126),
                  width: 10,
                ),
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/trading.jpg')),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigator.pushNamed(context, '/dashboard');
                Navigator.of(context).push(_createRoute()); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 9, 126, 126),
              ),
              child: const Text(
                'See Dashboard',
                style: TextStyle(
                  color: Colors.white, 
                ),
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const DashboardPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

