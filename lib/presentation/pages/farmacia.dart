import 'package:flutter/material.dart';
import '../../data/services/farmacia_clima_services.dart';
import '../../data/models/farmacia_model.dart';

class FarmaciaPage extends StatefulWidget {
  const FarmaciaPage({super.key});

  @override
  State<FarmaciaPage> createState() => _FarmaciaPageState();
}

class _FarmaciaPageState extends State<FarmaciaPage> {
  Farmacia? farmacia;
  bool isLoading = true;
  String error = '';

  static const double _defaultLat = -33.4567;
  static const double _defaultLng = -70.6543;

  @override
  void initState() {
    super.initState();
    cargarFarmacia();
  }

  Future<void> cargarFarmacia() async {
    setState(() {
      isLoading = true;
      error = '';
    });
    try {
      final data = await ApiService.getFarmacias(_defaultLat, _defaultLng);

      if (!mounted) return;

      setState(() {
        farmacia = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Widget buildCard(String titulo, String valor, IconData icono) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icono, color: Colors.green),
        title: Text(titulo),
        subtitle: Text(valor, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(
                'No se pudo obtener la farmacia más cercana.\n$error',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: cargarFarmacia,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (farmacia == null) {
      return const Center(child: Text('No hay información de farmacias.'));
    }

    final f = farmacia!;

    return RefreshIndicator(
      onRefresh: cargarFarmacia,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text(
            'Farmacia más cercana',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          buildCard('Cadena', f.cadena, Icons.local_pharmacy),
          buildCard('Nombre', f.nombre, Icons.store),
          buildCard('Dirección', f.direccion, Icons.location_on),
          buildCard('Teléfono', f.telefono.toString(), Icons.phone),
          buildCard(
            'Horario',
            '${f.aperturaNormal} - ${f.cierreNormal}',
            Icons.access_time,
          ),
        ],
      ),
    );
  }
}