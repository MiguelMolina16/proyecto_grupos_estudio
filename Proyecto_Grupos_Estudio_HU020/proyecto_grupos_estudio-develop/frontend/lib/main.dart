import 'package:flutter/material.dart';
import 'package:proyecto_grupos_estudio/widgets/asistencia.dart';
import 'package:proyecto_grupos_estudio/widgets/crear_reunion.dart';
import 'package:proyecto_grupos_estudio/widgets/consultar_reuniones_fecha.dart';
import 'package:proyecto_grupos_estudio/widgets/estadisticas_tareas.dart';

void main() => runApp(const Aplicacion());

class Aplicacion extends StatefulWidget {
  const Aplicacion({super.key});

  @override
  State<Aplicacion> createState() => _AplicacionState();
}

class _AplicacionState extends State<Aplicacion> {
  int _index = 0;

  final List<Widget> _pantallas = const [
    Asistencia(),
    CrearReunionWidget(),
    ConsultarReunionesFechaWidget(),
    EstadisticasTareasWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    const titulos = [
      'HU005 - Registrar Asistencia',
      'HU014 - Crear Reunión',
      'HU020 - Consultar reuniones',
      'HU028 - Tareas y Estadísticas',
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de grupos de estudio',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text(titulos[_index]),
          backgroundColor: Colors.blue,
        ),
        body: _pantallas[_index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.how_to_reg),
              label: 'Asistencia',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Crear reunión',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Consultar reuniones',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Tareas/Stats',
            ),
          ],
        ),
      ),
    );
  }
}
