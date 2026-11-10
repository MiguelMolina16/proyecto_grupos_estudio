
class Grupo {
  final String gruId;
  final String gruNombre;
  final String? gruDescripcion;

  const Grupo({
    required this.gruId,
    required this.gruNombre,
    this.gruDescripcion,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      gruId: json['gruId']?.toString() ?? '',
      gruNombre: json['gruNombre']?.toString() ?? '',
      gruDescripcion: json['gruDescripcion']?.toString(),
    );
  }
}
