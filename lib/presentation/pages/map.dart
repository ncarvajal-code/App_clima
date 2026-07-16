import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/services/location_services.dart';
import '../../core/utils/paletas.dart';

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
    setState(() {
      _loading = true;
      _error = "";
    });
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
        backgroundColor: kBg,
        body: Center(child: CircularProgressIndicator(color: kPrimary)),
      );
    }

    if (_error.isNotEmpty) {
      return Scaffold(
        backgroundColor: kBg,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: kError, size: 48),
                const SizedBox(height: 12),
                Text(
                  "No se pudo obtener tu ubicación.\n$_error",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: kTextStrong),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _cargarUbicacion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // MAPA
    return Scaffold(
      backgroundColor: kBg,
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
                    color: kAccentClima,
                    shape: BoxShape.circle,
                    border: Border.all(color: kSurface, width: 3),
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