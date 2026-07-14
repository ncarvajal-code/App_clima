import 'package:flutter/material.dart';
import '../../data/services/farmacia_clima_services.dart';
import '../../data/models/farmacia_model.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  Farmacia? farmacia;
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    cargarFarmacia();
  }

  Future<void> cargarFarmacia() async {
    try {
      final data = await ApiService.getFarmacias(-33.4489, -70.6693);

      if (!mounted) return;

      setState(() {
        farmacia = data.isNotEmpty ? data.first : null;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return Center(child: Text('Error en la carga del servidor intenta mas tarde'));
    }

    if (farmacia == null) {
      return const Center(child: Text('No hay farmacias cercanas'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_pharmacy,
                  size: 60, color: Colors.green),

              const SizedBox(height: 10),

              Text(
                farmacia!.nombre,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(farmacia!.direccion),

              const SizedBox(height: 10),

              Text('📞 ${farmacia!.telefono}'),

              const SizedBox(height: 10),

              Text(
                  '🕒 ${farmacia!.aperturaNormal} - ${farmacia!.cierreNormal}'),

              const SizedBox(height: 10),

              Text('🏪 ${farmacia!.cadena}'),
            ],
          ),
        ),
      ),
    );
  }
}