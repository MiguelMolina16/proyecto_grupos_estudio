import 'package:flutter/material.dart';
import 'package:proyecto_grupos_estudio/widgets/autenticacion.dart';

class PantallaInicial extends StatelessWidget {
  const PantallaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Autenticacion(),
      ),
    );
  }
}