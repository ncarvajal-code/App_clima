import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'presentation/pages/login.dart';
import 'presentation/pages/home.dart';
import 'core/utils/global.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print(" ERROR FIREBASE: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmacias App',
      debugShowCheckedModeBanner: false,

      //login
      initialRoute: isLogged ? '/home' : '/login',

      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
