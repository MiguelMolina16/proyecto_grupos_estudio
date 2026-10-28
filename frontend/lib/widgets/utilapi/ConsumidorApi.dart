import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../../modelos/usuario.dart';

class ServiciosApi {
  final String apiUrl = 'http://localhost:8620/kick';

  FutureOr<Usuario?> autenticarUsuario(
      String email, String password) async {
    print('datos recibidos : $email clave $password');

    if (email.isEmpty || password.isEmpty) {
      print('Error al enviar datos');
      return null;
    }

    final url = Uri.parse('$apiUrl/usuarios/autenticar');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      print('Código de respuesta: ${response.statusCode}');
      print('Respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Usuario.fromJson(jsonResponse);
      } else {
        print('Error en la autenticación: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error al conectar con el servidor: $e');
      return null;
    }
  }

  FutureOr<void> crear(
    String nombres,
    String apellidos,
    String email,
    String password,
    String rol,
  ) async {
    print('Registrando usuario: $email');

    final url = Uri.parse('$apiUrl/usuarios');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nombres': nombres,
          'apellidos': apellidos,
          'email': email,
          'password': password,
          'rol': rol,
        }),
      );

      print('Código de respuesta: ${response.statusCode}');
      print('Respuesta: ${response.body}');
    } catch (e) {
      print('Error al conectar con el servidor: $e');
    }
  }

  FutureOr<void> consultar() async {
    final url = Uri.parse('$apiUrl/usuarios');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Código de respuesta: ${response.statusCode}');
      print('Respuesta: ${response.body}');
    } catch (e) {
      print('Error al conectar con el servidor: $e');
    }
  }
}