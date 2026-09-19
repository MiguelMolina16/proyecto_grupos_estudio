import 'package:flutter/material.dart';
import 'package:proyecto_grupos_estudio/widgets/asistencia.dart';

void main() => runApp(const Aplicacion());

class Aplicacion extends StatelessWidget {
  const Aplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gestion Docente",
      home: PantallaAsistencia(),
    );
  }
}

class PantallaAsistencia extends StatelessWidget {
  const PantallaAsistencia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HU005 - Registrar Asistencia"),
        backgroundColor: Colors.blue,
      ),
      body: const Asistencia(),
      backgroundColor: Colors.grey[300],
    );
  }
}