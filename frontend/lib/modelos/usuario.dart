class Usuario {
  final String id;
  final String nombres;
  final String apellidos;
  final String email;
  final String rol;

  Usuario({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.email,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['usuId'].toString(),
      nombres: json['usuNombres'],
      apellidos: json['usuApellidos'],
      email: json['usuEmail'],
      rol: json['usuRol'],
    );
  }
}