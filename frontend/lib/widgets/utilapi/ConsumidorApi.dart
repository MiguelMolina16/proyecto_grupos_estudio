import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../../modelos/usuario.dart';

class ServiciosApi {
  final String apiUrl = 'http://localhost:8862/api/propietarios/autenticar';

  FutureOr<Propietario?> autenticarUsuario(String usuario, String clave) async {
    print('datos recibidos : $usuario clave $clave');
    if (usuario.isEmpty || clave.isEmpty) {
      print('Error al enviar datos');
      return null;
    }
    final url = Uri.parse(apiUrl);

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nombreUsuario': usuario,
        'clave': clave,
      }),
    );

    if (response.statusCode == 200) {
      // Si la solicitud fue exitosa, procesa la respuesta
      print('Autenticación exitosa: ${response.body}');
      try {
        final jsonResponse = json.decode(response.body);
        return Propietario.fromJson(jsonResponse);
      } catch (e) {
        print('Error al decodificar el JSON: $e');
        return null;
      }
    } else {
      // Si la solicitud falló, maneja el error
      print('Error en la autenticación: ${response.statusCode}');
      return null;
    }
  }

  FutureOr<void> crear(String usuario, String clave, String codigo,
      String nombrecompleto) async {
    print('datos recibidos : $usuario clave $clave');
    if (usuario.isEmpty || clave.isEmpty) {
      print('Error al enviar datos');
      return;
    }
    final url = Uri.parse("http://localhost:8862/api/propietarios/");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nombreUsuario': usuario,
        'clave': clave,
        'codigo': codigo,
        'nombreCompleto': nombrecompleto
      }),
    );

    if (response.statusCode == 200) {
      // Si la solicitud fue exitosa, procesa la respuesta
      print('Autenticación exitosa: ${response.body}');
    } else {
      // Si la solicitud falló, maneja el error
      print('Error en la autenticación: ${response.statusCode}');
    }
  }

  FutureOr<void> consultar() async {
    final url = Uri.parse("http://localhost:8862/api/propietarios/");
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      // Si la solicitud fue exitosa, procesa la respuesta
      print('Autenticación exitosa: ${response.body}');
    } else {
      // Si la solicitud falló, maneja el error
      print('Error en la autenticación: ${response.statusCode}');
    }
  }
}
