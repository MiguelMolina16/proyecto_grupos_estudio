class EstadisticaParticipacion {
  final String usuId;
  final String usuNombres;
  final String usuApellidos;
  final int totalReuniones;
  final int asistencias;
  final double porcentajeAsistencia;
  final int totalTareas;
  final int tareasCompletadas;
  final double porcentajeTareas;

  EstadisticaParticipacion({
    required this.usuId,
    required this.usuNombres,
    required this.usuApellidos,
    required this.totalReuniones,
    required this.asistencias,
    required this.porcentajeAsistencia,
    required this.totalTareas,
    required this.tareasCompletadas,
    required this.porcentajeTareas,
  });

  factory EstadisticaParticipacion.fromJson(Map<String, dynamic> json) => EstadisticaParticipacion(
        usuId: json['usuId'] ?? '',
        usuNombres: json['usuNombres'] ?? '',
        usuApellidos: json['usuApellidos'] ?? '',
        totalReuniones: json['totalReuniones'] ?? 0,
        asistencias: json['asistencias'] ?? 0,
        porcentajeAsistencia: (json['porcentajeAsistencia'] ?? 0).toDouble(),
        totalTareas: json['totalTareas'] ?? 0,
        tareasCompletadas: json['tareasCompletadas'] ?? 0,
        porcentajeTareas: (json['porcentajeTareas'] ?? 0).toDouble(),
      );
}