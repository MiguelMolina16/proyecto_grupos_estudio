import 'package:flutter/material.dart';
import 'package:proyecto_grupos_estudio/widgets/asistencia.dart';
import 'package:proyecto_grupos_estudio/widgets/crear_reunion.dart';
import 'package:proyecto_grupos_estudio/widgets/estadisticas_tareas.dart';
import 'package:proyecto_grupos_estudio/widgets/registro.dart';

void main() {
  runApp(const Aplicacion());
}

class Aplicacion extends StatelessWidget {
  const Aplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Estudio',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
      ),
      home: const PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _index = 0;

  final List<Widget> _pantallas = const [
    Registro(),
    Asistencia(),
    EstadisticasTareasWidget(),
    CrearReunion(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _index == 0
              ? 'Registro de Usuarios'
              : _index == 1
                  ? 'Registrar Asistencia'
                  : _index == 2
                      ? 'Tareas y Estadísticas'
                      : 'Crear reunión',
        ),
      ),
      body: _pantallas[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Registro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_reg),
            label: 'Asistencia',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Tareas/Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available_outlined),
            label: 'Crear reunión',
          ),
        ],
      ),
    );
  }
}