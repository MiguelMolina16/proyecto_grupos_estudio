class Reunion {
  final String? reuId;
  final String gruId;
  final String? reuFecha;
  final String? reuHora;
  final String? reuLocalizacion;
  final String? reuDescripcion;

  Reunion({
    this.reuId,
    required this.gruId,
    this.reuFecha,
    this.reuHora,
    this.reuLocalizacion,
    this.reuDescripcion,
  });

  factory Reunion.fromJson(Map<String, dynamic> json) => Reunion(
        reuId: json['reuId'],
        gruId: json['gruId'] ?? '',
        reuFecha: json['reuFecha'],
        reuHora: json['reuHora'],
        reuLocalizacion: json['reuLocalizacion'],
        reuDescripcion: json['reuDescripcion'],
      );

  String get etiqueta => '${reuDescripcion ?? "Reunión"} - ${reuFecha ?? ""}';
}