class Waether {
  final String nombre;
  final String direccion;
  final double latitud;
  final double longitud;

  Waether({
    required this.nombre,
    required this.direccion,
    required this.latitud,
    required this.longitud,
  });

  factory Waether.fromJson(Map<String, dynamic> json) {
    return Waether(
      nombre: json['local_nombre'] ?? '',
      direccion: json['local_direccion'] ?? '',
      latitud: double.parse(json['local_lat'] ?? '0'),
      longitud: double.parse(json['local_lng'] ?? '0'),
    );
  }
}