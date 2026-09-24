import 'package:flutter/material.dart';
import 'package:proyecto_grupos_estudio/widgets/asistencia.dart';

class PantallaAsistencia extends StatelessWidget {
  const PantallaAsistencia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registrar asistencia',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.fact_check_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: const SafeArea(
        child: Asistencia(),
      ),
    );
  }
}