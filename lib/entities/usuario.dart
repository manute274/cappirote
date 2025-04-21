class Usuario {
  final int id;
  final String nombre;
  final String correo;
  final String avatar;
  final String rol;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    this.avatar = '',
    this.rol = 'Usuario',
  });
}