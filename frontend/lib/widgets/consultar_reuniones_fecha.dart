import 'package:flutter/material.dart';
import '../modelos/grupo.dart';
import '../modelos/reunion.dart';
import 'utilapi/ServiciosGestion.dart';

class ConsultarReunionesFechaWidget extends StatefulWidget {
  const ConsultarReunionesFechaWidget({super.key});

  @override
  State<ConsultarReunionesFechaWidget> createState() => _ConsultarReunionesFechaWidgetState();
}

class _ConsultarReunionesFechaWidgetState extends State<ConsultarReunionesFechaWidget> {
  final ServiciosGestion _api = ServiciosGestion();
  List<Grupo> _grupos = [];
  String? _grupoSeleccionado;
  DateTime? _fechaSeleccionada;
  List<Reunion> _resultados = [];
  bool _cargando = true;
  bool _buscando = false;

  @override
  void initState() {
    super.initState();
    _cargarGrupos();
  }

  Future<void> _cargarGrupos() async {
    try {
      final data = await _api.getGrupos();
      setState(() {
        _grupos = data;
        _cargando = false;
      });
    } catch (e) {
      setState(() => _cargando = false);
      _msg('Error al cargar grupos: $e', false);
    }
  }

  Future<void> _buscar() async {
    if (_grupoSeleccionado == null || _fechaSeleccionada == null) {
      _msg('Seleccione grupo y fecha', false);
      return;
    }
    setState(() => _buscando = true);
    try {
      final fechaStr = '${_fechaSeleccionada!.year}-${_fechaSeleccionada!.month.toString().padLeft(2, '0')}-${_fechaSeleccionada!.day.toString().padLeft(2, '0')}';
      final res = await _api.getReunionesPorFecha(_grupoSeleccionado!, fechaStr);
      setState(() {
        _resultados = res;
        _buscando = false;
      });
    } catch (e) {
      setState(() => _buscando = false);
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
    return _cargando
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Seleccione un grupo', border: OutlineInputBorder()),
                  value: _grupoSeleccionado,
                  items: _grupos.map((g) => DropdownMenuItem(value: g.gruId, child: Text(g.gruNombre))).toList(),
                  onChanged: (v) => setState(() => _grupoSeleccionado = v),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _fechaSeleccionada ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) setState(() => _fechaSeleccionada = picked);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Seleccione una fecha', border: OutlineInputBorder()),
                    child: Text(_fechaSeleccionada == null ? 'Sin fecha' : '${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}'),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _buscando ? null : _buscar,
                  child: Text(_buscando ? 'Buscando...' : 'Buscar reuniones'),
                ),
                const SizedBox(height: 24),
                if (_resultados.isEmpty)
                  const Text('No hay reuniones en esa fecha.')
                else
                  ..._resultados.map((r) => Card(
                        child: ListTile(
                          title: Text(r.reuDescripcion ?? 'Sin descripción'),
                          subtitle: Text('${r.reuFecha} - ${r.reuHora}'),
                        ),
                      )),
              ],
            ),
          );
  }
}
