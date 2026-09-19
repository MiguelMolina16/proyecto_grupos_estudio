class Propietario {
  final int codigo;
  final String nombreCompleto;
  final String nombreUsuario;
  final String clave;
  Propietario({
    required this.codigo,
    required this.nombreCompleto,
    required this.nombreUsuario,
    required this.clave,
  });
  factory Propietario.fromJson(Map<String, dynamic> json) {
    return Propietario(
      codigo: json['codigo'],
      nombreCompleto: json['nombreCompleto'],
      nombreUsuario: json['nombreUsuario'],
      clave: json['clave'],
    );
  }
}
