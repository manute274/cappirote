class Noticia {
  final int id;
  final String titulo;
  final String cuerpo;
  final DateTime fecha;
  final String imagen;

  Noticia({
    this.id = 0,
    required this.titulo,
    required this.cuerpo,
    required this.fecha,
    required this.imagen,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'],
      titulo: json['titulo'],
      cuerpo: json['cuerpo'],
      fecha: DateTime.parse(json['fecha']),
      imagen: json['imagen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'cuerpo': cuerpo,
      'fecha': fecha.toIso8601String(),
      'imagen': imagen,
    };
  }
}