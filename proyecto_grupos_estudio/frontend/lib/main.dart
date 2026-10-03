import 'package:flutter/material.dart';
import 'package:proyecto_grupos_estudio/widgets/asistencia.dart';
import 'package:proyecto_grupos_estudio/widgets/grupo.dart';

void main() => runApp(const Aplicacion());

class Aplicacion extends StatefulWidget {
  const Aplicacion({super.key});

  @override
  State<Aplicacion> createState() => _AplicacionState();
}

class _AplicacionState extends State<Aplicacion> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gestion Docente",
      home: Scaffold(
        appBar: AppBar(
          title: Text(_index == 0
              ? "HU003 - Crear Grupo"
              : "HU005 - Registrar Asistencia"),
          backgroundColor: Colors.blue,
        ),
        body: _index == 0 ? const GrupoWidget() : const Asistencia(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.group_add),
              label: 'Grupos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.how_to_reg),
              label: 'Asistencia',
            ),
          ],
        ),
      ),
    );
  }
}