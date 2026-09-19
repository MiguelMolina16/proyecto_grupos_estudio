import 'package:proyecto_grupos_estudio/widgets/autenticacion.dart';
import 'package:flutter/material.dart';

class PantallaInicial extends StatelessWidget {
  const PantallaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Autenticarse"),
        backgroundColor: Colors.blue,
      ),
      body: Autenticacion(),
      backgroundColor: Colors.grey[300],
    );
  }
}
