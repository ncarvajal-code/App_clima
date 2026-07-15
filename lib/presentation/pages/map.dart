import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/services/location_services.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  LatLng? _miUbicacion;
  bool _loading = true;
  String _error = "";

  @override
  void initState() {
    super.initState();
    _cargarUbicacion();
  }

  Future<void> _cargarUbicacion() async {
    try {
      Position pos = await LocationServices.getCurrentLocation();

      final ubicacion = LatLng(pos.latitude, pos.longitude);

      setState(() {
        _miUbicacion = ubicacion;
        _loading = false;
      });

      //Centrar mapa
      Future.delayed(const Duration(milliseconds: 300), () {
        _mapController.move(ubicacion, 16);
      });

    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    // LOADING
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error.isNotEmpty) {
      return Scaffold(
        body: Center(child: Text("Error: $_error")),
      );
    }

    // MAPA
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _miUbicacion!,
          initialZoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate:
                "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
            subdomains: ['a', 'b', 'c', 'd'],
            userAgentPackageName: 'com.tuempresa.farmaciasapp',
          ),
          
          // Ubicacion actual
          MarkerLayer(
            markers: [
              Marker(
                point: _miUbicacion!,
                width: 60,
                height: 60,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}