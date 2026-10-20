import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../../modelos/usuario.dart';
import '../../modelos/reunion.dart';
import '../../modelos/tarea.dart';
import '../../modelos/estadistica.dart';

class ServiciosGestion {
  //final String apiUrl = 'http://localhost:8620/kick';
  final String apiUrl = 'https://proyectogruposestudio-production.up.railway.app/kick';

  FutureOr<List<Reunion>> getReuniones() async {
    final url = Uri.parse('$apiUrl/reuniones');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((j) => Reunion.fromJson(j)).toList();
    } else {
      throw Exception('Error al cargar reuniones: ${response.statusCode}');
    }
  }

  FutureOr<List<Usuario>> getIntegrantes(String reuId) async {
    final url = Uri.parse('$apiUrl/asistencias/reunion/$reuId/integrantes');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((j) => Usuario.fromJson(j)).toList();
    } else {
      throw Exception('Error al cargar integrantes: ${response.statusCode}');
    }
  }

  FutureOr<String> registrarAsistencia(String reuId, List<String> usuIds) async {
    final url = Uri.parse('$apiUrl/asistencias');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'reuId': reuId, 'usuIds': usuIds}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'OK';
    }
    try {
      final err = json.decode(response.body);
      return err['message'] ?? err['details'] ?? 'Error desconocido';
    } catch (_) {
      return 'Error: ${response.statusCode}';
    }
  }

  // ==========================================
  // MÉTODOS NUEVOS PARA LA HU028 (TAREAS Y ESTADÍSTICAS)
  // ==========================================

  FutureOr<List<Tarea>> getTareasPorReunion(String reuId) async {
    final url = Uri.parse('$apiUrl/tareas/reunion/$reuId');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((j) => Tarea.fromJson(j)).toList();
    } else {
      throw Exception('Error al cargar tareas: ${response.statusCode}');
    }
  }

  FutureOr<String> crearTarea(String reuId, String? usuId, String descripcion) async {
    final url = Uri.parse('$apiUrl/tareas');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'reuId': reuId,
        'usuId': usuId, // Si es null, el backend asigna a todo el grupo
        'tarDescripcion': descripcion,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'OK';
    }
    try {
      final err = json.decode(response.body);
      return err['error'] ?? 'Error al crear tarea';
    } catch (_) {
      return 'Error: ${response.statusCode}';
    }
  }

  FutureOr<String> cambiarEstadoTarea(String tarId, bool completada) async {
    final url = Uri.parse('$apiUrl/tareas/$tarId/estado');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'completada': completada}),
    );
    if (response.statusCode == 200) {
      return 'OK';
    }
    return 'Error al actualizar tarea: ${response.statusCode}';
  }

  FutureOr<EstadisticaParticipacion> getEstadisticas(String gruId, String usuId) async {
    final url = Uri.parse('$apiUrl/estadisticas/$gruId/$usuId');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      return EstadisticaParticipacion.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar estadísticas: ${response.statusCode}');
    }
  }
}