import 'package:hello_me/screens/main_screen.dart';
import 'package:provider/provider.dart';
import './providers/user_notifier.dart';
import './providers/suggestions_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text(snapshot.error.toString(),
                      textDirection: TextDirection.ltr)));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserNotifier()),
        ChangeNotifierProxyProvider<UserNotifier, SuggestionsNotifier>(
          create: (context) => SuggestionsNotifier(),
          update: (context, userNotifier, suggestionsNotifier) =>
              suggestionsNotifier!..update(userNotifier),
        ),
      ],
      child:MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        home: const RandomWords(),
      ),
    );
  }
}


