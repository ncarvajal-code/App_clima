import 'package:flutter/material.dart';
import '../../data/services/farmacia_clima_services.dart';
import '../../data/models/clima_model.dart';

class ClimaPage extends StatefulWidget {
  const ClimaPage({super.key});

  @override
  State<ClimaPage> createState() => _ClimaPageState();
}

class _ClimaPageState extends State<ClimaPage> {
  Clima? clima;
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    cargarClima();
  }

  Future<void> cargarClima() async {
    try {
      final data = await ApiService.getClima(-33.4567, -70.6543);

      if (!mounted) return;

      setState(() {
        clima = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  //  Widget de tarjeta
  Widget buildCard(String titulo, String valor, IconData icono) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icono, color: Colors.blue),
        title: Text(titulo),
        subtitle: Text(valor, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  // 🔹 Detecta el valor centinela "sin datos" del sensor (-32768)
  String formatValor(num valor, String unidad) {
    if (valor == -32768) return 'Sin datos';
    return '$valor $unidad';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Actual'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : RefreshIndicator(
                  onRefresh: cargarClima,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      //
                      Center(
                        child: Column(
                          children: [
                            const Icon(Icons.wb_sunny,
                                size: 80, color: Colors.orange),
                            Text(
                              '${clima!.temperatura}°C',
                              style: const TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Humedad: ${clima!.humedad}%',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 📊 DETALLES
                      buildCard(
                          'Viento',
                          '${clima!.velocidadViento} m/s',
                          Icons.air),

                      buildCard(
                          'Racha de viento',
                          '${clima!.rachaViento} m/s',
                          Icons.warning),

                      buildCard(
                          'Radiación solar',
                          '${clima!.radiacionSolar}',
                          Icons.wb_sunny_outlined),

                      buildCard(
                          'Presión',
                          formatValor(clima!.presion, 'hPa'),
                          Icons.speed),

                      buildCard(
                          'UV',
                          '${clima!.ultravioleta}',
                          Icons.sunny),

                      buildCard(
                          'Precipitación',
                          formatValor(clima!.precipitacion, 'mm'),
                          Icons.grain),

                      buildCard(
                          'Punto de rocío',
                          '${clima!.puntoRocio}°C',
                          Icons.water_drop),

                      const SizedBox(height: 20),

                      Center(
                        child: Text(
                          'Actualizado: ${clima!.fechaHora}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}