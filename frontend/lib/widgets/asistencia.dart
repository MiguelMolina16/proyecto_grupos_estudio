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
      final r = await _api.getReuniones();
      setState(() {
        _reuniones = r;
        _cargandoReuniones = false;
      });
    } catch (e) {
      setState(() => _cargandoReuniones = false);
      _msg('Error reuniones: $e', false);
    }
  }

  Future<void> _selReunion(Reunion? r) async {
    if (r == null) return;
    setState(() {
      _reunionSel = r;
      _integrantes = [];
      _seleccionados.clear();
      _cargandoIntegrantes = true;
    });
    try {
      final lista = await _api.getIntegrantes(r.reuId!);
      setState(() {
        _integrantes = lista;
        _cargandoIntegrantes = false;
      });
    } catch (e) {
      setState(() => _cargandoIntegrantes = false);
      _msg('Error integrantes: $e', false);
    }
  }

  Future<void> _registrar() async {
    if (_reunionSel == null) return;
    if (_seleccionados.isEmpty) {
      _msg('Selecciona al menos un integrante', false);
      return;
    }
    setState(() => _enviando = true);
    try {
      final res = await _api.registrarAsistencia(
        _reunionSel!.reuId!,
        _seleccionados.toList(),
      );
      if (res == 'OK') {
        _msg('Asistencia registrada correctamente', true);
        setState(() => _seleccionados.clear());
      } else {
        _msg(res, false);
      }
    } catch (e) {
      _msg('$e', false);
    } finally {
      setState(() => _enviando = false);
    }
  }

  void _msg(String m, bool ok) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(m),
      backgroundColor: ok ? Colors.green : Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _cargandoReuniones
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<Reunion>(
                  decoration: const InputDecoration(
                    labelText: 'Selecciona una reunión',
                    border: OutlineInputBorder(),
                  ),
                  value: _reunionSel,
                  items: _reuniones
                      .map((r) => DropdownMenuItem(
                            value: r,
                            child: Text(r.etiqueta,
                                overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: _selReunion,
                ),
                const SizedBox(height: 16),
                if (_cargandoIntegrantes)
                  const Center(child: CircularProgressIndicator())
                else if (_reunionSel != null)
                  Expanded(
                    child: _integrantes.isEmpty
                        ? const Center(child: Text('Sin integrantes'))
                        : ListView.builder(
                            itemCount: _integrantes.length,
                            itemBuilder: (ctx, i) {
                              final e = _integrantes[i];
                              final id = e.estId!;
                              return CheckboxListTile(
                                title: Text(e.nombreCompleto),
                                subtitle: Text(e.estEmail ?? ''),
                                value: _seleccionados.contains(id),
                                onChanged: (v) => setState(() {
                                  if (v == true) {
                                    _seleccionados.add(id);
                                  } else {
                                    _seleccionados.remove(id);
                                  }
                                }),
                              );
                            },
                          ),
                  ),
                const SizedBox(height: 16),
                if (_reunionSel != null)
                  ElevatedButton.icon(
                    onPressed: _enviando ? null : _registrar,
                    icon: _enviando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(_enviando
                        ? 'Enviando...'
                        : 'Registrar asistencia (${_seleccionados.length})'),
                  ),
              ],
            ),
          );
  }
}