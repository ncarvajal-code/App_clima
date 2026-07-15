import 'package:flutter/material.dart';
import '../../data/services/location_services.dart';
import '../../data/services/farmacia_clima_services.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  Map<String, dynamic>? farmacia;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarFarmacia();
  }

  Future<void> cargarFarmacia() async {
    try {
      final pos = await LocationServices.getCurrentLocation();

      final data = await FarmaciaService.getFarmacia(
        pos.latitude,
        pos.longitude,
      );

      setState(() {
        farmacia = data;
        loading = false;
      });
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Farmacia más cercana",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 10),

          Text("Nombre: ${farmacia?['nombre'] ?? ''}"),
          Text("Dirección: ${farmacia?['direccion'] ?? ''}"),
          Text("Cadena: ${farmacia?['cadena'] ?? ''}"),
          Text("Horario: ${farmacia?['apertura_normal']} - ${farmacia?['cierre_normal']}"),
        ],
      ),
    );
  }
}