import 'package:flutter/material.dart';
import '../../core/utils/global.dart';
import 'login.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
                isLogged = false;
                Navigator.pushReplacement(context, MaterialPageRoute<void>( builder: (context) => LoginPage(),));
            },
          )
        ],
      ),
      body: Center(
        child: Text('Bienvenido a la app 🚀'),
      ),
    );
  }
}