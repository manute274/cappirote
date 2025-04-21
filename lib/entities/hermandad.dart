class Hermandad {
  final int id;
  final String nombre;
  final String apelativo;
  final int fundacion;
  final String titulares;
  final String sede;
  final String dia;
  final String itinerario;
  final String escudo;
  final List<String> images;

  Hermandad({
    required this.id,
    required this.nombre,
    required this.apelativo,
    required this.fundacion,
    required this.titulares,
    required this.sede,
    required this.dia,
    required this.itinerario,
    this.escudo = '',
    this.images = const [],
  });


  factory Hermandad.fromJson(Map<String, dynamic> json) {
    return Hermandad(
      id: json['id'],
      nombre: json['nombre'],
      apelativo: json['apelativo'] ?? '',
      fundacion: json['fundacion'],
      titulares: json['titulares'] ?? '',
      sede: json['sede'] ?? '',
      dia: json['dia'] ?? '',
      itinerario: json['itinerario'] ?? '',
      escudo: json['escudo'] ?? '',
      images: json['images'] ?? []
    );
  }
}