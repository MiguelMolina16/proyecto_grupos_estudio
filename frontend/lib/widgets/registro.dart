import 'package:flutter/material.dart';
import 'package:proyecto_grupos_estudio/widgets/textfieldgeneral.dart';
import 'package:proyecto_grupos_estudio/widgets/utilapi/ServiciosGestion.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final ServiciosGestion serviciosApi = ServiciosGestion();

  final TextEditingController controllerNombres =
      TextEditingController();

  final TextEditingController controllerApellidos =
      TextEditingController();

  final TextEditingController controllerEmail =
      TextEditingController();

  final TextEditingController controllerPassword =
      TextEditingController();

  String? rolSeleccionado;
  bool registrando = false;

  @override
  void dispose() {
    controllerNombres.dispose();
    controllerApellidos.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  Future<void> registrar() async {
    // Validar que todos los campos estén completos
    if (controllerNombres.text.trim().isEmpty ||
        controllerApellidos.text.trim().isEmpty ||
        controllerEmail.text.trim().isEmpty ||
        controllerPassword.text.isEmpty ||
        rolSeleccionado == null) {
      mostrarMensaje('Por favor complete todos los campos.');
      return;
    }

    setState(() {
      registrando = true;
    });

    final resultado = await serviciosApi.registrarUsuario(
      controllerNombres.text.trim(),
      controllerApellidos.text.trim(),
      controllerEmail.text.trim(),
      controllerPassword.text,
      rolSeleccionado!,
    );

    if (!mounted) return;

    setState(() {
      registrando = false;
    });

    if (resultado == 'OK') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario registrado correctamente.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } else {
      mostrarMensaje(resultado);
    }
  }

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarse'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 30),

                const Text(
                  'Crear cuenta',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                TextFieldGeneral(
                  labelCaja: 'Nombres',
                  hintText: 'Ingrese sus nombres',
                  onChanged: (value) {},
                  icon: Icons.person_outline,
                  controller: controllerNombres,
                ),

                const SizedBox(height: 15),

                TextFieldGeneral(
                  labelCaja: 'Apellidos',
                  hintText: 'Ingrese sus apellidos',
                  onChanged: (value) {},
                  icon: Icons.person_outline,
                  controller: controllerApellidos,
                ),

                const SizedBox(height: 15),

                TextFieldGeneral(
                  labelCaja: 'Correo',
                  hintText: 'Ingrese su correo',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {},
                  icon: Icons.email_outlined,
                  controller: controllerEmail,
                ),

                const SizedBox(height: 15),

                TextFieldGeneral(
                  labelCaja: 'Contraseña',
                  hintText: 'Ingrese una contraseña',
                  onChanged: (value) {},
                  icon: Icons.lock_outline,
                  obscureText: true,
                  controller: controllerPassword,
                ),

                const SizedBox(height: 15),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: rolSeleccionado,
                    decoration: const InputDecoration(
                      labelText: 'Rol',
                      prefixIcon: Icon(Icons.badge_outlined),
                      border: InputBorder.none,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Estudiante',
                        child: Text('Estudiante'),
                      ),
                      DropdownMenuItem(
                        value: 'Profesor',
                        child: Text('Profesor'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        rolSeleccionado = value;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 25),

                ElevatedButton(
                  onPressed: registrando ? null : registrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: registrando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Registrarse'),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}