class Evento {
  final int id;
  final String nombre;
  final String descripcion;
  final DateTime fecha;
  final String nombreUsuario;

  Evento({
    this.id = 0,
    required this.nombre,
    required this.descripcion,
    required this.fecha,
    required this.nombreUsuario
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      fecha: json['fecha'],
      nombreUsuario: json['nombre_usuario'],
    );
  }
}
