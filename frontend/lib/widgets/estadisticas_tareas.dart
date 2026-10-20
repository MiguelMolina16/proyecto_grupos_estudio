import 'package:flutter/material.dart';
import '../modelos/reunion.dart';
import '../modelos/usuario.dart';
import '../modelos/tarea.dart';
import '../modelos/estadistica.dart';
import 'utilapi/ServiciosGestion.dart';

class EstadisticasTareasWidget extends StatefulWidget {
  const EstadisticasTareasWidget({super.key});

  @override
  State<EstadisticasTareasWidget> createState() => _EstadisticasTareasWidgetState();
}

class _EstadisticasTareasWidgetState extends State<EstadisticasTareasWidget> {
  final ServiciosGestion _api = ServiciosGestion();

  List<Reunion> _reuniones = [];
  Reunion? _reunionSel;
  List<Usuario> _integrantes = [];
  Usuario? _integranteSel;
  
  EstadisticaParticipacion? _stats;
  List<Tarea> _tareasReunion = [];

  bool _cargandoReuniones = true;
  bool _cargandoDatos = false;
  bool _enviandoTarea = false;

  final TextEditingController _tareaCtrl = TextEditingController();

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

  Future<void> _seleccionarReunion(Reunion? r) async {
    if (r == null) return;
    setState(() {
      _reunionSel = r;
      _integranteSel = null;
      _stats = null;
      _tareasReunion = [];
      _cargandoDatos = true;
    });

    try {
      final ints = await _api.getIntegrantes(r.reuId!);
      final tar = await _api.getTareasPorReunion(r.reuId!);
      setState(() {
        _integrantes = ints;
        _tareasReunion = tar;
        _cargandoDatos = false;
      });
    } catch (e) {
      setState(() => _cargandoDatos = false);
      _msg('Error al cargar datos: $e', false);
    }
  }

  Future<void> _seleccionarIntegrante(Usuario? u) async {
    if (u == null || _reunionSel == null) return;
    setState(() {
      _integranteSel = u;
      _stats = null;
      _cargandoDatos = true;
    });

    try {
      final stats = await _api.getEstadisticas(_reunionSel!.gruId, u.usuId!);
      setState(() {
        _stats = stats;
        _cargandoDatos = false;
      });
    } catch (e) {
      setState(() => _cargandoDatos = false);
      _msg('Error estadísticas: $e', false);
    }
  }

  Future<void> _crearTarea(bool paraTodos) async {
    if (_reunionSel == null || _tareaCtrl.text.trim().isEmpty) {
      _msg('Escribe una descripción', false);
      return;
    }

    if (!paraTodos && _integranteSel == null) {
      _msg('Selecciona un integrante o elige "Asignar a Todos"', false);
      return;
    }

    setState(() => _enviandoTarea = true);
    try {
      final res = await _api.crearTarea(
        _reunionSel!.reuId!,
        paraTodos ? null : _integranteSel?.usuId,
        _tareaCtrl.text.trim(),
      );

      if (res == 'OK') {
        _msg(paraTodos ? 'Tarea asignada al grupo' : 'Tarea asignada', true);
        _tareaCtrl.clear();
        // Recargamos las tareas de la reunión
        final tar = await _api.getTareasPorReunion(_reunionSel!.reuId!);
        setState(() => _tareasReunion = tar);
      } else {
        _msg(res, false);
      }
    } catch (e) {
      _msg('$e', false);
    } finally {
      setState(() => _enviandoTarea = false);
    }
  }

  Future<void> _cambiarEstado(Tarea t) async {
    try {
      final res = await _api.cambiarEstadoTarea(t.tarId!, !t.tarCompletada);
      if (res == 'OK') {
        _seleccionarReunion(_reunionSel); // Recargar datos
      } else {
        _msg(res, false);
      }
    } catch (e) {
      _msg('$e', false);
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
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<Reunion>(
                  decoration: const InputDecoration(labelText: 'Selecciona una reunión', border: OutlineInputBorder()),
                  value: _reunionSel,
                  items: _reuniones.map((r) => DropdownMenuItem(value: r, child: Text(r.etiqueta, overflow: TextOverflow.ellipsis))).toList(),
                  onChanged: _seleccionarReunion,
                ),
                const SizedBox(height: 16),
                if (_reunionSel != null && !_cargandoDatos) ...[
                  DropdownButtonFormField<Usuario>(
                    decoration: const InputDecoration(labelText: 'Selecciona un integrante para ver estadísticas', border: OutlineInputBorder()),
                    value: _integranteSel,
                    items: _integrantes.map((u) => DropdownMenuItem(value: u, child: Text(u.nombreCompleto))).toList(),
                    onChanged: _seleccionarIntegrante,
                  ),
                  const SizedBox(height: 16),
                  
                  // TARJETAS DE ESTADÍSTICAS
                  if (_stats != null)
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text('Estadísticas de ${_stats!.usuNombres}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text('Asistencia', style: TextStyle(color: Colors.grey[700])),
                                    Text('${_stats!.asistencias} / ${_stats!.totalReuniones}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    Text('${_stats!.porcentajeAsistencia}%', style: const TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Tareas', style: TextStyle(color: Colors.grey[700])),
                                    Text('${_stats!.tareasCompletadas} / ${_stats!.totalTareas}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    Text('${_stats!.porcentajeTareas}%', style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // REGISTRO DE TAREA
                  const Text('Registrar nueva tarea en esta reunión', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _tareaCtrl,
                    decoration: const InputDecoration(labelText: 'Descripción de la tarea', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: (_enviandoTarea || _integranteSel == null) ? null : () => _crearTarea(false),
                          icon: const Icon(Icons.person_add),
                          label: const Text('Asignar a Integrante'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _enviandoTarea ? null : () => _crearTarea(true),
                          icon: const Icon(Icons.group_add),
                          label: const Text('Asignar a Todos'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // LISTA DE TAREAS
                  const Text('Tareas de esta reunión', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (_tareasReunion.isEmpty)
                    const Text('No hay tareas registradas en esta reunión.')
                  else
                    ..._tareasReunion.map((t) {
                      // Buscamos los datos del estudiante al que se le asignó la tarea
                      final estAsignado = _integrantes.firstWhere(
                        (u) => u.usuId == t.usuId,
                        orElse: () => Usuario(
                          usuId: 'Desconocido', 
                          usuNombres: 'Estudiante', 
                          usuApellidos: 'No encontrado', 
                          usuEmail: '', 
                          usuRol: ''
                        ),
                      );

                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: t.tarCompletada,
                            onChanged: (v) => _cambiarEstado(t),
                          ),
                          title: Text(t.tarDescripcion),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Asignada a: ${estAsignado.usuNombres} ${estAsignado.usuApellidos}', 
                                   style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blueGrey)),
                              Text(t.tarCompletada ? 'Completada' : 'Pendiente',
                                  style: TextStyle(
                                    color: t.tarCompletada ? Colors.green : Colors.orange,
                                    fontWeight: FontWeight.bold
                                  )),
                            ],
                          ),
                        ),
                      );
                    }),
                ]
              ],
            ),
          );
  }
}