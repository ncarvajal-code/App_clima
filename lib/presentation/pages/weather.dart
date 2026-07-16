import 'package:flutter/material.dart';
import '../../data/services/farmacia_clima_services.dart';
import '../../data/models/clima_model.dart';
import '../../core/utils/paletas.dart';

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
    setState(() {
      isLoading = true;
      error = '';
    });
    try {
      final data = await ApiService.getClima(-33.4567, -70.6543);

      if (!mounted) return;

      setState(() {
        clima = data;
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

  //  Widget de tarjeta
  Widget buildCard(String titulo, String valor, IconData icono) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: const BoxDecoration(
              color: kAccentClimaTint,
              shape: BoxShape.circle,
            ),
            child: Icon(icono, color: kAccentClima, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kTextSoft,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: kTextStrong,
                  ),
                ),
              ],
            ),
          ),
        ],
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
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kSurface,
        elevation: 0,
        centerTitle: true,
        title: const Text('Clima Actual', style: TextStyle(color: kTextStrong)),
        iconTheme: const IconThemeData(color: kTextStrong),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: kAccentClima))
          : error.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            color: kError, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          'No se pudo obtener el clima.\n$error',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: kTextStrong),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: cargarClima,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentClima,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: kAccentClima,
                  onRefresh: cargarClima,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Tarjeta destacada de temperatura
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        decoration: BoxDecoration(
                          color: kAccentClimaTint,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: const BoxDecoration(
                                color: kSurface,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.wb_sunny_rounded,
                                  size: 36, color: kAccentClima),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${clima!.temperatura}°C',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: kTextStrong,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Humedad: ${clima!.humedad}%',
                              style: const TextStyle(
                                  fontSize: 15, color: kTextSoft),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 📊 DETALLES
                      buildCard('Viento', '${clima!.velocidadViento} m/s',
                          Icons.air_rounded),

                      buildCard('Racha de viento',
                          '${clima!.rachaViento} m/s', Icons.warning_rounded),

                      buildCard('Radiación solar', '${clima!.radiacionSolar}',
                          Icons.wb_sunny_outlined),

                      buildCard('Presión', formatValor(clima!.presion, 'hPa'),
                          Icons.speed_rounded),

                      buildCard('UV', '${clima!.ultravioleta}',
                          Icons.brightness_high_rounded),

                      buildCard('Precipitación',
                          formatValor(clima!.precipitacion, 'mm'),
                          Icons.grain_rounded),

                      buildCard('Punto de rocío', '${clima!.puntoRocio}°C',
                          Icons.water_drop_rounded),

                      const SizedBox(height: 16),

                      Center(
                        child: Text(
                          'Actualizado: ${clima!.fechaHora}',
                          style: const TextStyle(color: kTextSoft, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}