class Clima {
  final double temperatura;
  final String descripcion;

  Clima({
    required this.temperatura,
    required this.descripcion,
  });

  factory Clima.fromJson(Map<String, dynamic> json) {
    return Clima(
      temperatura: json['temp'] ?? 0,
      descripcion: json['description'] ?? '',
    );
  }
}