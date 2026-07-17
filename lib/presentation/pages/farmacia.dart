import 'package:flutter/material.dart';
import '../../data/services/farmacia_clima_services.dart';
import '../../data/services/location_services.dart';
import '../../data/models/farmacia_model.dart';
import '../../core/utils/paletas.dart';

class FarmaciaPage extends StatefulWidget {
  /// Si se pasan, se usan tal cual (para coincidir con la ubicación que ya
  /// usó la tarjeta del Home). Si son null, la pantalla pide su propia
  /// ubicación al GPS.
  final double? lat;
  final double? lng;

  const FarmaciaPage({super.key, this.lat, this.lng});

  @override
  State<FarmaciaPage> createState() => _FarmaciaPageState();
}

class _FarmaciaPageState extends State<FarmaciaPage> {
  Farmacia? farmacia;
  bool isLoading = true;
  bool sinResultados = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    cargarFarmacia();
  }

  Future<void> cargarFarmacia() async {
    setState(() {
      isLoading = true;
      sinResultados = false;
      error = '';
    });
    try {
      double lat;
      double lng;

      if (widget.lat != null && widget.lng != null) {
        lat = widget.lat!;
        lng = widget.lng!;
      } else {
        final pos = await LocationServices.getCurrentLocation();
        lat = pos.latitude;
        lng = pos.longitude;
      }

      final data = await FarmaciaService.getFarmacia(lat, lng);

      if (!mounted) return;

      setState(() {
        farmacia = Farmacia.fromJson(data);
        isLoading = false;
      });
    } on FarmaciaNoEncontradaException {
      if (!mounted) return;
      setState(() {
        sinResultados = true;
        farmacia = null;
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

  /// Compara la hora actual contra apertura/cierre (formato "HH:mm" o
  /// "HH:mm:ss"). Soporta horarios que cruzan la medianoche.
  bool? _estaAbierta(String apertura, String cierre) {
    TimeOfDay? parse(String s) {
      final partes = s.split(':');
      if (partes.length < 2) return null;
      final h = int.tryParse(partes[0]);
      final m = int.tryParse(partes[1]);
      if (h == null || m == null) return null;
      return TimeOfDay(hour: h, minute: m);
    }

    final open = parse(apertura);
    final close = parse(cierre);
    if (open == null || close == null) return null;

    final now = TimeOfDay.now();
    final nowMin = now.hour * 60 + now.minute;
    final openMin = open.hour * 60 + open.minute;
    final closeMin = close.hour * 60 + close.minute;

    if (closeMin > openMin) {
      return nowMin >= openMin && nowMin < closeMin;
    }
    // El horario cruza la medianoche.
    return nowMin >= openMin || nowMin < closeMin;
  }

  Widget _infoTile(String titulo, String valor, IconData icono) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: const BoxDecoration(
              color: kPrimaryTint,
              shape: BoxShape.circle,
            ),
            child: Icon(icono, color: kPrimary, size: 18),
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
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBg,
      child: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimary),
            );
          }

          if (sinResultados) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.nightlight_round,
                        color: kTextSoft, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'No hay farmacias de turno cerca de tu ubicación\nen este momento.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kTextStrong),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: cargarFarmacia,
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
            );
          }

          if (error.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: kError, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'No se pudo obtener la farmacia más cercana.\n$error',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: kTextStrong),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: cargarFarmacia,
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
            );
          }

          if (farmacia == null) {
            return const Center(
              child: Text(
                'No hay información de farmacias.',
                style: TextStyle(color: kTextSoft),
              ),
            );
          }

          final f = farmacia!;
          final telefonoTexto =
              f.telefono == 0 ? 'No disponible' : f.telefono.toString();
          final abierta = _estaAbierta(f.aperturaNormal, f.cierreNormal);

          return RefreshIndicator(
            color: kPrimary,
            onRefresh: cargarFarmacia,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Encabezado con cadena + estado abierta/cerrada
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: kPrimaryTint,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: kSurface,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.local_pharmacy_rounded,
                            color: kPrimary, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              f.cadena,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: kTextStrong,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              f.nombre,
                              style: const TextStyle(
                                fontSize: 13,
                                color: kTextSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (abierta != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: kSurface,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: abierta ? kPrimary : kTextSoft,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                abierta ? 'Abierta' : 'Cerrada',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: abierta ? kPrimary : kTextSoft,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                _infoTile('Dirección', f.direccion, Icons.location_on_rounded),
                _infoTile('Teléfono', telefonoTexto, Icons.phone_rounded),
                _infoTile(
                  'Horario',
                  '${f.aperturaNormal} - ${f.cierreNormal}',
                  Icons.access_time_rounded,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}