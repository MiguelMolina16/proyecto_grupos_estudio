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

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((j) => Reunion.fromJson(j)).toList();
    } else {
      throw Exception(
        'Error al cargar reuniones: ${response.statusCode}',
      );
    }
  }

  FutureOr<List<Estudiante>> getIntegrantes(String reuId) async {
    final url = Uri.parse(
      '$apiUrl/asistencias/reunion/$reuId/integrantes',
    );

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((j) => Estudiante.fromJson(j)).toList();
    } else {
      throw Exception(
        'Error al cargar integrantes: ${response.statusCode}',
      );
    }
  }

  FutureOr<String> registrarAsistencia(
      String reuId, List<String> estIds) async {
    final url = Uri.parse('$apiUrl/asistencias');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'reuId': reuId,
        'estIds': estIds,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'OK';
    }

    try {
      final err = json.decode(response.body);

      return err['message'] ??
          err['details'] ??
          'Error desconocido';
    } catch (_) {
      return 'Error: ${response.statusCode}';
    }
  }

  Future<String> registrarUsuario(
    String nombres,
    String apellidos,
    String email,
    String password,
    String rol,
  ) async {
    final url = Uri.parse('$apiUrl/usuarios');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'nombres': nombres,
          'apellidos': apellidos,
          'email': email,
          'password': password,
          'rol': rol,
        }),
      );

      // El backend puede responder 201 Created
      // o 200 OK.
      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return 'OK';
      }

      // Intentamos obtener el mensaje enviado por el backend.
      try {
        final error = jsonDecode(response.body);

        if (error is Map<String, dynamic>) {
          if (error['message'] != null) {
            return error['message'].toString();
          }

          if (error['details'] != null) {
            return error['details'].toString();
          }

          if (error['violations'] != null) {
            return error['violations'].toString();
          }
        }
      } catch (_) {
        // Si la respuesta no contiene JSON,
        // continuamos con el mensaje genérico.
      }

      return 'No se pudo registrar el usuario. '
          'Código: ${response.statusCode}';
    } catch (e) {
      return 'No se pudo conectar con el servidor.';
    }
  }
}