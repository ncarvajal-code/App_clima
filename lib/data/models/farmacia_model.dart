class Farmacia {
  final String cadena;
  final int tienda;
  final String nombre;
  final String direccion;
  final int telefono;
  final String aperturaNormal;
  final String cierreNormal;

  Farmacia({
    required this.cadena,
    required this.tienda,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.aperturaNormal,
    required this.cierreNormal,
  });

  //Parse
  factory Farmacia.fromJson(Map<String, dynamic> json) {
    return Farmacia(
      cadena: json['cadena'],
      tienda: json['tienda'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      aperturaNormal: json['apertura_normal'],
      cierreNormal: json['cierre_normal'],
    );
  }
}