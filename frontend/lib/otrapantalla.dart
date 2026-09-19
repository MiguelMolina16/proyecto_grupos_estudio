import 'package:flutter/material.dart';

import 'modelos/usuario.dart';

class OtraPantalla extends StatelessWidget {
  final Propietario propietario;

  const OtraPantalla({super.key, required this.propietario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Otra Pantalla')),
      body: Center(
        child: Text('Propietario encontrado: ${propietario.nombreCompleto}'),
      ),
    );
  }
}
