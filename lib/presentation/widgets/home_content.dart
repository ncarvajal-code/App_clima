import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/services/location_services.dart';
import '../../data/services/farmacia_clima_services.dart';
import '../../core/utils/paletas.dart';
import '../pages/farmacia.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  Map<String, dynamic>? farmacia;
  Position? _pos;
  bool loading = true;
  bool sinResultados = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    cargarFarmacia();
  }

  Future<void> cargarFarmacia() async {
    setState(() {
      loading = true;
      sinResultados = false;
      error = '';
    });
    try {
      final pos = await LocationServices.getCurrentLocation();
      _pos = pos;

      final data = await FarmaciaService.getFarmacia(
        pos.latitude,
        pos.longitude,
      );

      if (!mounted) return;
      setState(() {
        farmacia = data;
        loading = false;
      });
    } on FarmaciaNoEncontradaException {
      if (!mounted) return;
      setState(() {
        sinResultados = true;
        farmacia = null;
        loading = false;
      });
    } catch (e) {
      print("ERROR: $e");
      if (!mounted) return;
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  String _saludo() {
    final hora = DateTime.now().hour;
    if (hora < 12) return 'Buenos días';
    if (hora < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  /// Compara la hora actual contra apertura/cierre (formato "HH:mm" o
  /// "HH:mm:ss"). Soporta horarios que cruzan la medianoche.
  bool? _estaAbierta() {
    final apertura = farmacia?['apertura_normal'];
    final cierre = farmacia?['cierre_normal'];
    if (apertura == null || cierre == null) return null;

    TimeOfDay? parse(String s) {
      final partes = s.split(':');
      if (partes.length < 2) return null;
      final h = int.tryParse(partes[0]);
      final m = int.tryParse(partes[1]);
      if (h == null || m == null) return null;
      return TimeOfDay(hour: h, minute: m);
    }

    final open = parse(apertura.toString());
    final close = parse(cierre.toString());
    if (open == null || close == null) return null;

    final now = TimeOfDay.now();
    final nowMin = now.hour * 60 + now.minute;
    final openMin = open.hour * 60 + open.minute;
    final closeMin = close.hour * 60 + close.minute;

    if (closeMin > openMin) {
      return nowMin >= openMin && nowMin < closeMin;
    }
    // El horario cruza la medianoche (ej. turno 08:00 -> 07:59 del otro día)
    return nowMin >= openMin || nowMin < closeMin;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBg,
      child: RefreshIndicator(
        color: kPrimary,
        onRefresh: cargarFarmacia,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            Text(
              _saludo(),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: kTextStrong,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tu farmacia más cercana y el clima, al instante.',
              style: TextStyle(fontSize: 14, color: kTextSoft, height: 1.3),
            ),
            const SizedBox(height: 24),
            _buildFarmaciaCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmaciaCard() {
    if (loading) {
      return Container(
        height: 132,
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kBorder),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: kPrimary),
        ),
      );
    }

    if (sinResultados) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.nightlight_round, color: kTextSoft),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'No hay farmacias de turno cerca de ti en este momento.',
                style: TextStyle(color: kTextStrong),
              ),
            ),
            TextButton(
              onPressed: cargarFarmacia,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (error.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: kError),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'No se pudo cargar la farmacia más cercana.',
                style: TextStyle(color: kTextStrong),
              ),
            ),
            TextButton(
              onPressed: cargarFarmacia,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    final nombre = (farmacia?['nombre'] ?? '').toString();
    final direccion = (farmacia?['direccion'] ?? '').toString();
    final cadena = (farmacia?['cadena'] ?? '').toString();
    final apertura = (farmacia?['apertura_normal'] ?? '--:--').toString();
    final cierre = (farmacia?['cierre_normal'] ?? '--:--').toString();
    final abierta = _estaAbierta();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Farmacia más cercana')),
              body: FarmaciaPage(lat: _pos?.latitude, lng: _pos?.longitude),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: kPrimaryTint,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: kSurface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_pharmacy_rounded,
                      color: kPrimary, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Farmacia más cercana',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kTextSoft,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                if (abierta != null) _EstadoBadge(abierta: abierta),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, color: kTextSoft),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              nombre.isEmpty ? cadena : nombre,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: kTextStrong,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              direccion,
              style: const TextStyle(fontSize: 14, color: kTextSoft, height: 1.3),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 15, color: kTextSoft),
                const SizedBox(width: 6),
                Text(
                  '$apertura - $cierre',
                  style: const TextStyle(fontSize: 13, color: kTextSoft),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EstadoBadge extends StatelessWidget {
  final bool abierta;
  const _EstadoBadge({required this.abierta});

  @override
  Widget build(BuildContext context) {
    final color = abierta ? kPrimary : kTextSoft;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            abierta ? 'Abierta' : 'Cerrada',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}