import 'package:flutter/material.dart';
import 'package:proyecto_grupos_estudio/widgets/asistencia.dart';
// import 'package:proyecto_grupos_estudio/widgets/grupo.dart'; // Comentado porque es de otra HU
import 'package:proyecto_grupos_estudio/widgets/estadisticas_tareas.dart';

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
              ? "HU005 - Registrar Asistencia"
              : "HU028 - Tareas y Estadísticas"), // Título ajustado a las 2 pestañas actuales
          backgroundColor: Colors.blue,
        ),
        body: _index == 0
            ? const Asistencia()
            // : _index == 1
            //     ? const GrupoWidget() // Comentado porque es de otra HU
            //     : const EstadisticasTareasWidget(),
            : const EstadisticasTareasWidget(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.how_to_reg), label: 'Asistencia'),
            // BottomNavigationBarItem(icon: Icon(Icons.group_add), label: 'Grupos'), // Comentado
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Tareas/Stats'),
          ],
        ),
      ),
    );
  }
}