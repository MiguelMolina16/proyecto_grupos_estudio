class Grupo {
  final String? gruId;
  final String gruNombre;
  final String gruDescripcion;
  final String? gruCreacion;

  Grupo({
    this.gruId,
    required this.gruNombre,
    required this.gruDescripcion,
    this.gruCreacion,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) => Grupo(
        gruId: json['gruId'],
        gruNombre: json['gruNombre'] ?? '',
        gruDescripcion: json['gruDescripcion'] ?? '',
        gruCreacion: json['gruCreacion'],
      );

  Map<String, dynamic> toJson() => {
        'gruNombre': gruNombre,
        'gruDescripcion': gruDescripcion,
      };
}