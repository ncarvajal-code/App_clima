class Clima {
  final String idObservacion;
  final DateTime fechaHora;
  final double temperatura;
  final int humedad;
  final double velocidadViento;
  final int direccionViento;
  final int radiacionSolar;
  final double presionAbsoluta;
  final int precipitacion;
  final double puntoRocio;
  final double rachaViento;
  final double presion;
  final int tasaLluvia;
  final int ultravioleta;
  final int lluviaDiaria;

  Clima({
    required this.idObservacion,
    required this.fechaHora,
    required this.temperatura,
    required this.humedad,
    required this.velocidadViento,
    required this.direccionViento,
    required this.radiacionSolar,
    required this.presionAbsoluta,
    required this.precipitacion,
    required this.puntoRocio,
    required this.rachaViento,
    required this.presion,
    required this.tasaLluvia,
    required this.ultravioleta,
    required this.lluviaDiaria,
  });
  // Parse 
  factory Clima.fromJson(Map<String, dynamic> json) {
    return Clima(
      idObservacion: json['id_observacion'],
      fechaHora: DateTime.parse(json['fecha_hora']),
      temperatura: (json['temperatura'] as num).toDouble(),
      humedad: json['humedad'],
      velocidadViento: (json['velocidad_viento'] as num).toDouble(),
      direccionViento: json['direccion_viento'],
      radiacionSolar: json['radiacion_solar'],
      presionAbsoluta: (json['presion_absoluta'] as num).toDouble(),
      precipitacion: json['precipitacion'],
      puntoRocio: (json['punto_rocio'] as num).toDouble(),
      rachaViento: (json['racha_viento'] as num).toDouble(),
      presion: (json['presion'] as num).toDouble(),
      tasaLluvia: json['tasalluvia'],
      ultravioleta: json['ultravioleta'],
      lluviaDiaria: json['lluviadiaria'],
    );
  }
}