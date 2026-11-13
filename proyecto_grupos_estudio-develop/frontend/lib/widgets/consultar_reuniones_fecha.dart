import 'package:flutter/material.dart';
import '../modelos/reunion.dart';
import 'utilapi/ServiciosGestion.dart';

class ConsultarReunionesFechaWidget extends StatefulWidget {
  const ConsultarReunionesFechaWidget({super.key});

  @override
  State<ConsultarReunionesFechaWidget> createState() =>
      _ConsultarReunionesFechaWidgetState();
}

class _ConsultarReunionesFechaWidgetState
    extends State<ConsultarReunionesFechaWidget> {
  final ServiciosGestion _api = ServiciosGestion();
  List<Map<String, dynamic>> _grupos = [];
  List<Reunion> _reuniones = [];
  String? _grupoSeleccionado;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  bool _cargandoGrupos = true;
  bool _consultando = false;
  bool _consultado = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarGrupos();
  }

  Future<void> _cargarGrupos() async {
    try {
      final grupos = await _api.getGrupos();
      if (!mounted) return;
      setState(() {
        _grupos = grupos;
        _cargandoGrupos = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargandoGrupos = false;
        _error = 'No se pudieron cargar los grupos: $e';
      });
    }
  }

  Future<DateTime?> _elegirFecha(DateTime? inicial, String ayuda) async {
    final hoy = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: inicial ?? _fechaInicio ?? hoy,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: ayuda,
    );
  }

  String _fechaISO(DateTime fecha) =>
      '${fecha.year.toString().padLeft(4, '0')}-'
      '${fecha.month.toString().padLeft(2, '0')}-'
      '${fecha.day.toString().padLeft(2, '0')}';

  String _fechaLegible(DateTime? fecha) {
    if (fecha == null) return 'Seleccionar fecha';
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }

  void _mostrarMensaje(String texto, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(texto),
      backgroundColor: error ? Colors.red : Colors.green,
    ));
  }

  Future<void> _consultar() async {
    if (_grupoSeleccionado == null) {
      _mostrarMensaje('Selecciona un grupo de estudio.', error: true);
      return;
    }
    if (_fechaInicio == null) {
      _mostrarMensaje('Selecciona una fecha inicial.', error: true);
      return;
    }
    final fin = _fechaFin ?? _fechaInicio!;
    if (_fechaInicio!.isAfter(fin)) {
      _mostrarMensaje(
        'La fecha inicial no puede ser posterior a la fecha final.',
        error: true,
      );
      return;
    }

    setState(() {
      _consultando = true;
      _error = null;
      _consultado = false;
      _reuniones = [];
    });

    try {
      final resultado = await _api.getReunionesPorFecha(
        gruId: _grupoSeleccionado!,
        fechaInicio: _fechaISO(_fechaInicio!),
        fechaFin: _fechaISO(fin),
      );
      if (!mounted) return;
      setState(() {
        _reuniones = resultado;
        _consultado = true;
      });
      if (resultado.isEmpty) {
        _mostrarMensaje('No hay reuniones para el período seleccionado.');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _consultando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargandoGrupos) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'HU020 - Consultar reuniones por fecha',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Selecciona un grupo y una fecha o un rango de fechas.'),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _grupoSeleccionado,
            decoration: const InputDecoration(
              labelText: 'Grupo de estudio',
              border: OutlineInputBorder(),
            ),
            items: _grupos.map((grupo) {
              final id = grupo['gruId']?.toString();
              final nombre = grupo['gruNombre']?.toString() ?? 'Grupo sin nombre';
              return DropdownMenuItem<String>(
                value: id,
                child: Text(nombre, overflow: TextOverflow.ellipsis),
              );
            }).where((item) => item.value != null).toList(),
            onChanged: _grupos.isEmpty
                ? null
                : (value) => setState(() => _grupoSeleccionado = value),
          ),
          if (_grupos.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'No hay grupos disponibles para consultar.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              final fecha = await _elegirFecha(_fechaInicio, 'Fecha inicial');
              if (fecha != null) setState(() => _fechaInicio = fecha);
            },
            icon: const Icon(Icons.calendar_today),
            label: Text('Desde: ${_fechaLegible(_fechaInicio)}'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              final fecha = await _elegirFecha(_fechaFin, 'Fecha final');
              if (fecha != null) setState(() => _fechaFin = fecha);
            },
            icon: const Icon(Icons.event),
            label: Text('Hasta: ${_fechaLegible(_fechaFin)} (opcional)'),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => setState(() => _fechaFin = null),
            icon: const Icon(Icons.clear),
            label: const Text('Consultar un solo día'),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: (_consultando || _grupos.isEmpty) ? null : _consultar,
            icon: _consultando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.search),
            label: Text(_consultando ? 'Consultando...' : 'Consultar reuniones'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          if (_consultado && _reuniones.isEmpty && _error == null) ...[
            const SizedBox(height: 24),
            const Icon(Icons.event_busy, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            const Center(child: Text('No se encontraron reuniones en este período.')),
          ],
          if (_reuniones.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('Resultados: ${_reuniones.length}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._reuniones.map((reunion) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.event_note),
                    title: Text(reunion.reuDescripcion?.isNotEmpty == true
                        ? reunion.reuDescripcion!
                        : 'Reunión sin descripción'),
                    subtitle: Text([
                      if (reunion.reuFecha != null) 'Fecha: ${reunion.reuFecha}',
                      if (reunion.reuHora != null) 'Hora: ${reunion.reuHora}',
                      if (reunion.reuLocalizacion != null && reunion.reuLocalizacion!.isNotEmpty)
                        'Lugar/modalidad: ${reunion.reuLocalizacion}',
                    ].join('\n')),
                    isThreeLine: true,
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
