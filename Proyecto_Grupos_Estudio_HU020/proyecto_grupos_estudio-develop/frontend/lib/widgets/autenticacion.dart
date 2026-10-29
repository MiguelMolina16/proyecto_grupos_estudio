import 'package:proyecto_grupos_estudio/modelos/usuario.dart';
import 'package:proyecto_grupos_estudio/otrapantalla.dart';
import 'package:proyecto_grupos_estudio/widgets/textfieldgeneral.dart';
import 'package:proyecto_grupos_estudio/widgets/utilapi/ConsumidorApi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Autenticacion extends StatelessWidget {
  final ServiciosApi serviciosApi = ServiciosApi();
  late final Propietario? propietario;

  Autenticacion({super.key, this.propietario});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controllerUsuario = TextEditingController();
    final TextEditingController controllerClave = TextEditingController();

    autenticar() async {
      print('Invocar el metodo API de autenticacion');
      print(controllerUsuario.text);
      print(controllerClave.text);
      final propietario = await serviciosApi
          .autenticarUsuario(controllerUsuario.text, controllerClave.text);

      if (propietario != null) {
        print('Propietario encontrado: ${propietario.nombreCompleto}');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtraPantalla(propietario: propietario)),
        );
      } else {
        print('No se encontró el propietario.');
      }
    }

    // TODO: implement build
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 224, 212, 212),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  const Text(
                    "LAPLICA ION",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Iniciar sesión",
                          style: TextStyle(
                              color: Color(0xff720404),
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Text("Registrarse",
                          style: TextStyle(
                              color: Color(0xff720404),
                              fontSize: 20,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  _textFieldUsuario(controllerUsuario),
                  const SizedBox(
                    height: 25.0,
                  ),
                  _textFieldClave(controllerClave),
                  const SizedBox(
                    height: 25.0,
                  ),
                  _raiseButton(autenticar)
                ]))));
  }
}

Widget _textFieldUsuario(TextEditingController controller) {
  return TextFieldGeneral(
      labelCaja: "Nombre de usuario",
      hintText: "Escriba aca el nombre del usuario ",
      onChanged: (value) {},
      icon: Icons.person_outline,
      controller: controller);
}

Widget _textFieldClave(TextEditingController controller) {
  return TextFieldGeneral(
      labelCaja: "Contraseña",
      onChanged: (value) {},
      icon: Icons.lock_outline_rounded,
      obscureText: true,
      controller: controller);
}

Widget _raiseButton(VoidCallback onPressed) {
  return OutlinedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7), // Esquinas redondeadas
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 24, vertical: 12), // Color del texto del botón
      ),
      child: const Text("Ingresar"));
}
