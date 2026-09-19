class Estudiante {
  final String? estId;
  final String estNombres;
  final String estApellidos;
  final String? estEmail;

  Estudiante({
    this.estId,
    required this.estNombres,
    required this.estApellidos,
    this.estEmail,
  });

  factory Estudiante.fromJson(Map<String, dynamic> json) => Estudiante(
        estId: json['estId'],
        estNombres: json['estNombres'] ?? '',
        estApellidos: json['estApellidos'] ?? '',
        estEmail: json['estEmail'],
      );

  String get nombreCompleto => '$estNombres $estApellidos';
}