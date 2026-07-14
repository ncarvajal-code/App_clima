import 'package:flutter/material.dart';
import '../../core/utils/global.dart';
import 'login.dart';
import 'weather.dart';
import 'map.dart';
import '../widgets/home_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  //  Paginas
  final List<Widget> _pages = [
    ClimaPage(),
    HomeContent(),
    MapPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

void logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => LoginPage()),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmacias App'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          )
        ],
      ),

      //  Contenido dinamico
      body: _pages[_selectedIndex],

      // 🔥 BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny), // clima
            label: 'Clima',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // hogar
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map), // mapa
            label: 'Mapa',
          ),
        ],
      ),
    );
  }
}