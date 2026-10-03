class Usuario {
  final String? usuId;
  final String usuNombres;
  final String usuApellidos;
  final String? usuEmail;
  final String? usuRol;

  Usuario({
    this.usuId,
    required this.usuNombres,
    required this.usuApellidos,
    this.usuEmail,
    this.usuRol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        usuId: json['usuId'],
        usuNombres: json['usuNombres'] ?? '',
        usuApellidos: json['usuApellidos'] ?? '',
        usuEmail: json['usuEmail'],
        usuRol: json['usuRol'],
      );

  String get nombreCompleto => '$usuNombres $usuApellidos';
}