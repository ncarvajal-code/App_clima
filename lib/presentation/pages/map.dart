import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;

  final LatLng centro = const LatLng(-33.4489, -70.6693); // Santiago

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: centro,
          zoom: 14,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        myLocationEnabled: true, // GPS
        myLocationButtonEnabled: true,
      ),
    );
  }
}