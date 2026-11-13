class Tarea {
  final String? tarId;
  final String reuId;
  final String usuId;
  final String tarDescripcion;
  final bool tarCompletada;

  Tarea({
    this.tarId,
    required this.reuId,
    required this.usuId,
    required this.tarDescripcion,
    required this.tarCompletada,
  });

  factory Tarea.fromJson(Map<String, dynamic> json) => Tarea(
        tarId: json['tarId'],
        reuId: json['reuId'] ?? '',
        usuId: json['usuId'] ?? '',
        tarDescripcion: json['tarDescripcion'] ?? '',
        tarCompletada: json['tarCompletada'] ?? false,
      );
}