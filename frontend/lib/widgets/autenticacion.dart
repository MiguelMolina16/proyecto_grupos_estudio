import 'package:flutter/material.dart';
import 'package:proyecto_grupos_estudio/pantallaasistencia.dart';
import 'package:proyecto_grupos_estudio/widgets/registro.dart';
import 'package:proyecto_grupos_estudio/widgets/textfieldgeneral.dart';
import 'package:proyecto_grupos_estudio/widgets/utilapi/ConsumidorApi.dart';

class Autenticacion extends StatefulWidget {
  const Autenticacion({super.key});

  @override
  State<Autenticacion> createState() => _AutenticacionState();
}

class _AutenticacionState extends State<Autenticacion> {
  final ServiciosApi serviciosApi = ServiciosApi();

  final TextEditingController controllerUsuario =
      TextEditingController();

  final TextEditingController controllerClave =
      TextEditingController();

  bool _cargando = false;

  @override
  void dispose() {
    controllerUsuario.dispose();
    controllerClave.dispose();
    super.dispose();
  }

  Future<void> autenticar() async {
    if (controllerUsuario.text.trim().isEmpty ||
        controllerClave.text.isEmpty) {
      _mostrarMensaje(
        'Ingresa tu correo y contraseña.',
        false,
      );
      return;
    }

    setState(() {
      _cargando = true;
    });

    print('Invocar el metodo API de autenticacion');
    print(controllerUsuario.text);
    print(controllerClave.text);

    final usuario = await serviciosApi.autenticarUsuario(
      controllerUsuario.text.trim(),
      controllerClave.text,
    );

    if (!mounted) return;

    setState(() {
      _cargando = false;
    });

    if (usuario != null) {
      print(
        'Usuario encontrado: '
        '${usuario.nombres} ${usuario.apellidos}',
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PantallaAsistencia(),
        ),
      );
    } else {
      print('No se encontró el usuario.');

      _mostrarMensaje(
        'No se pudo iniciar sesión. '
        'Verifica tu correo y contraseña.',
        false,
      );
    }
  }

  void _mostrarMensaje(String mensaje, bool correcto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: correcto
            ? Colors.green
            : const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 430,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      _encabezado(),

                      const SizedBox(height: 32),

                      _textFieldUsuario(
                        controllerUsuario,
                      ),

                      const SizedBox(height: 18),

                      _textFieldClave(
                        controllerClave,
                      ),

                      const SizedBox(height: 26),

                      _botonIngresar(),

                      const SizedBox(height: 22),

                      const Divider(),

                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: _cargando
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const Registro(),
                                  ),
                                );
                              },
                        child: const Text(
                          '¿No tienes una cuenta? Regístrate',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _encabezado() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FE),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.school_rounded,
            size: 38,
            color: Color(0xFF2563EB),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Gestión de Docentes',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Inicia sesión para continuar',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _textFieldUsuario(
    TextEditingController controller,
  ) {
    return TextFieldGeneral(
      labelCaja: 'Correo electrónico',
      hintText: 'Escribe tu correo electrónico',
      onChanged: (value) {},
      icon: Icons.email_outlined,
      controller: controller,
    );
  }

  Widget _textFieldClave(
    TextEditingController controller,
  ) {
    return TextFieldGeneral(
      labelCaja: 'Contraseña',
      hintText: 'Escribe tu contraseña',
      onChanged: (value) {},
      icon: Icons.lock_outline_rounded,
      obscureText: true,
      controller: controller,
    );
  }

  Widget _botonIngresar() {
    return ElevatedButton(
      onPressed: _cargando ? null : autenticar,
      child: _cargando
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login_rounded),
                SizedBox(width: 10),
                Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}