import 'package:flutter/material.dart';
import '../../core/utils/global.dart';
import 'login.dart';
import 'map.dart'; // asegúrate que exista

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  // 🔥 Páginas
  final List<Widget> _pages = [
    Center(child: Text('Clima 🌤️')),
    Center(child: Text('Bienvenido a la app 🚀')),
    MapaPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void logout(BuildContext context) {
    isLogged = false;
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

      // 🔥 CONTENIDO DINÁMICO
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