
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

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      usuId: json['usuId']?.toString(),
      usuNombres: json['usuNombres']?.toString() ?? '',
      usuApellidos: json['usuApellidos']?.toString() ?? '',
      usuEmail: json['usuEmail']?.toString(),
      usuRol: json['usuRol']?.toString(),
    );
  }

  String get nombreCompleto => '$usuNombres $usuApellidos';

  // Alias para mantener compatibilidad con el código
  // que utiliza los nombres anteriores del modelo.
  String get id => usuId ?? '';
  String get nombres => usuNombres;
  String get apellidos => usuApellidos;
  String get email => usuEmail ?? '';
  String get rol => usuRol ?? '';
}
