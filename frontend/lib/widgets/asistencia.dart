import 'package:flutter/material.dart';
import '../modelos/estudiante.dart';
import '../modelos/reunion.dart';
import 'utilapi/ServiciosGestion.dart';

class Asistencia extends StatefulWidget {
  const Asistencia({super.key});

  @override
  State<Asistencia> createState() => _AsistenciaState();
}

class _AsistenciaState extends State<Asistencia> {
  final ServiciosGestion _api = ServiciosGestion();

  List<Reunion> _reuniones = [];
  Reunion? _reunionSel;
  List<Estudiante> _integrantes = [];

  final Set<String> _seleccionados = {};

  bool _cargandoReuniones = true;
  bool _cargandoIntegrantes = false;
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _cargarReuniones();
  }

  Future<void> _cargarReuniones() async {
    try {
      final reuniones = await _api.getReuniones();

      if (!mounted) return;

      setState(() {
        _reuniones = reuniones;
        _cargandoReuniones = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cargandoReuniones = false;
      });

      _msg(
        'No se pudieron cargar las reuniones.',
        false,
      );
    }
  }

  Future<void> _selReunion(Reunion? reunion) async {
    if (reunion == null) return;

    setState(() {
      _reunionSel = reunion;
      _integrantes = [];
      _seleccionados.clear();
      _cargandoIntegrantes = true;
    });

    try {
      final integrantes = await _api.getIntegrantes(
        reunion.reuId!,
      );

      if (!mounted) return;

      setState(() {
        _integrantes = integrantes;
        _cargandoIntegrantes = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cargandoIntegrantes = false;
      });

      _msg(
        'No se pudieron cargar los integrantes.',
        false,
      );
    }
  }

  Future<void> _registrar() async {
    if (_reunionSel == null) {
      _msg(
        'Selecciona una reunión.',
        false,
      );
      return;
    }

    if (_seleccionados.isEmpty) {
      _msg(
        'Selecciona al menos un integrante.',
        false,
      );
      return;
    }

    setState(() {
      _enviando = true;
    });

    try {
      final resultado = await _api.registrarAsistencia(
        _reunionSel!.reuId!,
        _seleccionados.toList(),
      );

      if (!mounted) return;

      if (resultado == 'OK') {
        _msg(
          'Asistencia registrada correctamente.',
          true,
        );

        setState(() {
          _seleccionados.clear();
        });
      } else {
        _msg(
          resultado,
          false,
        );
      }
    } catch (e) {
      if (!mounted) return;

      _msg(
        'No se pudo registrar la asistencia.',
        false,
      );
    } finally {
      if (mounted) {
        setState(() {
          _enviando = false;
        });
      }
    }
  }

  void _msg(String mensaje, bool correcto) {
    if (!mounted) return;

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
    if (_cargandoReuniones) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 850,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _encabezado(),

                  const SizedBox(height: 20),

                  _tarjetaReunion(),

                  const SizedBox(height: 20),

                  _tarjetaIntegrantes(),

                  const SizedBox(height: 20),

                  _botonRegistrar(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _encabezado() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.fact_check_outlined,
                color: Color(0xFF2563EB),
                size: 28,
              ),
            ),

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registrar asistencia',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Selecciona una reunión y marca los integrantes presentes.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tarjetaReunion() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.groups_outlined,
                  size: 22,
                  color: Color(0xFF2563EB),
                ),
                SizedBox(width: 10),
                Text(
                  'Reunión',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<Reunion>(
              decoration: const InputDecoration(
                labelText: 'Selecciona una reunión',
                prefixIcon: Icon(
                  Icons.event_outlined,
                ),
              ),
              value: _reunionSel,
              isExpanded: true,
              items: _reuniones.map(
                (reunion) {
                  return DropdownMenuItem<Reunion>(
                    value: reunion,
                    child: Text(
                      reunion.etiqueta,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ).toList(),
              onChanged: _cargandoIntegrantes
                  ? null
                  : _selReunion,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaIntegrantes() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.people_outline,
                  size: 22,
                  color: Color(0xFF2563EB),
                ),

                const SizedBox(width: 10),

                const Expanded(
                  child: Text(
                    'Integrantes',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),

                if (_reunionSel != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_seleccionados.length} seleccionados',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            if (_reunionSel == null)
              _estadoInicial()
            else if (_cargandoIntegrantes)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_integrantes.isEmpty)
              _sinIntegrantes()
            else
              _listaIntegrantes(),
          ],
        ),
      ),
    );
  }

  Widget _estadoInicial() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.touch_app_outlined,
            size: 40,
            color: Color(0xFF9CA3AF),
          ),
          SizedBox(height: 10),
          Text(
            'Selecciona una reunión',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Los integrantes aparecerán aquí.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sinIntegrantes() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.person_off_outlined,
            size: 40,
            color: Color(0xFF9CA3AF),
          ),
          SizedBox(height: 10),
          Text(
            'No hay integrantes',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Esta reunión no tiene integrantes registrados.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listaIntegrantes() {
    return Column(
      children: _integrantes.map(
        (estudiante) {
          final id = estudiante.estId!;

          final seleccionado =
              _seleccionados.contains(id);

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: seleccionado
                  ? const Color(0xFFEFF6FF)
                  : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: seleccionado
                    ? const Color(0xFFBFDBFE)
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: CheckboxListTile(
              value: seleccionado,
              onChanged: (valor) {
                setState(() {
                  if (valor == true) {
                    _seleccionados.add(id);
                  } else {
                    _seleccionados.remove(id);
                  }
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                estudiante.nombreCompleto,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              subtitle: Text(
                estudiante.estEmail ?? 'Sin correo registrado',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _botonRegistrar() {
    return ElevatedButton.icon(
      onPressed: _enviando ||
              _reunionSel == null ||
              _seleccionados.isEmpty
          ? null
          : _registrar,
      icon: _enviando
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : const Icon(
              Icons.save_outlined,
            ),
      label: Text(
        _enviando
            ? 'Registrando asistencia...'
            : 'Registrar asistencia',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}