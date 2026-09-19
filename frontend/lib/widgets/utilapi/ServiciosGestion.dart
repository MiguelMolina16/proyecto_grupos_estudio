import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../../modelos/estudiante.dart';
import '../../modelos/reunion.dart';

class ServiciosGestion {
  // Cambia según dónde corras Flutter:
  //   Flutter Web (Chrome):  http://localhost:8620/kick
  //   Emulador Android:      http://10.0.2.2:8620/kick
  //   Emulador iOS:          http://localhost:8620/kick
  final String apiUrl = 'http://localhost:8620/kick';

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

  FutureOr<List<Estudiante>> getIntegrantes(String reuId) async {
    final url = Uri.parse('$apiUrl/asistencias/reunion/$reuId/integrantes');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((j) => Estudiante.fromJson(j)).toList();
    } else {
      throw Exception('Error al cargar integrantes: ${response.statusCode}');
    }
  }

  FutureOr<String> registrarAsistencia(String reuId, List<String> estIds) async {
    final url = Uri.parse('$apiUrl/asistencias');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'reuId': reuId, 'estIds': estIds}),
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
}