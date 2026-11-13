import 'package:flutter/material.dart';
import 'utilapi/ServiciosGestion.dart';

class CrearReunionWidget extends StatefulWidget {
  const CrearReunionWidget({super.key});

  @override
  State<CrearReunionWidget> createState() => _CrearReunionWidgetState();
}

class _CrearReunionWidgetState extends State<CrearReunionWidget> {
  final ServiciosGestion _api = ServiciosGestion();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lugarCtrl = TextEditingController();
  final TextEditingController _descripcionCtrl = TextEditingController();

  List<Map<String, dynamic>> _grupos = [];
  String? _grupoSeleccionado;
  DateTime? _fecha;
  TimeOfDay? _hora;
  bool _cargandoGrupos = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargarGrupos();
  }

  @override
  void dispose() {
    _lugarCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
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
      setState(() => _cargandoGrupos = false);
      _mensaje('No se pudieron cargar los grupos: $e', false);
    }
  }

  Future<void> _elegirFecha() async {
    final ahora = DateTime.now();
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fecha ?? ahora,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Selecciona la fecha de la reunión',
    );
    if (fecha != null) setState(() => _fecha = fecha);
  }

  Future<void> _elegirHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: _hora ?? TimeOfDay.now(),
      helpText: 'Selecciona la hora de la reunión',
    );
    if (hora != null) setState(() => _hora = hora);
  }

  String _dosDigitos(int n) => n.toString().padLeft(2, '0');

  String get _fechaTexto => _fecha == null
      ? 'Seleccionar fecha'
      : '${_dosDigitos(_fecha!.day)}/${_dosDigitos(_fecha!.month)}/${_fecha!.year}';

  String get _horaTexto => _hora == null
      ? 'Seleccionar hora'
      : '${_dosDigitos(_hora!.hour)}:${_dosDigitos(_hora!.minute)}';

  void _mensaje(String texto, bool correcto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: correcto ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _crearReunion() async {
    if (!_formKey.currentState!.validate()) return;

    if (_grupoSeleccionado == null) {
      _mensaje('Selecciona un grupo de estudio.', false);
      return;
    }
    if (_fecha == null) {
      _mensaje('Selecciona la fecha de la reunión.', false);
      return;
    }
    if (_hora == null) {
      _mensaje('Selecciona la hora de la reunión.', false);
      return;
    }

    setState(() => _guardando = true);
    try {
      final fecha = '${_fecha!.year}-${_dosDigitos(_fecha!.month)}-${_dosDigitos(_fecha!.day)}';
      final hora = '${_dosDigitos(_hora!.hour)}:${_dosDigitos(_hora!.minute)}:00';

      final resultado = await _api.crearReunion(
        gruId: _grupoSeleccionado!,
        reuFecha: fecha,
        reuHora: hora,
        reuLocalizacion: _lugarCtrl.text.trim(),
        reuDescripcion: _descripcionCtrl.text.trim(),
      );

      if (!mounted) return;
      if (resultado == 'OK') {
        _mensaje('Reunión creada correctamente.', true);
        setState(() {
          _grupoSeleccionado = null;
          _fecha = null;
          _hora = null;
        });
        _lugarCtrl.clear();
        _descripcionCtrl.clear();
        _formKey.currentState!.reset();
      } else {
        _mensaje(resultado, false);
      }
    } catch (e) {
      _mensaje('Error al crear la reunión: $e', false);
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargandoGrupos) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'HU014 - Crear reunión asociada a grupo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Registra una reunión y asóciala a un grupo de estudio existente.'),
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
              onChanged: _grupos.isEmpty ? null : (value) {
                setState(() => _grupoSeleccionado = value);
              },
              validator: (value) => value == null ? 'Selecciona un grupo' : null,
            ),
            if (_grupos.isEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'No hay grupos disponibles. Primero debe existir un grupo de estudio.',
                style: TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _elegirFecha,
              icon: const Icon(Icons.calendar_month),
              label: Text(_fechaTexto),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _elegirHora,
              icon: const Icon(Icons.access_time),
              label: Text(_horaTexto),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lugarCtrl,
              decoration: const InputDecoration(
                labelText: 'Lugar o modalidad',
                hintText: 'Ej. Biblioteca central o virtual por Meet',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Indica el lugar o la modalidad'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descripcionCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripción de la reunión',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Escribe una descripción'
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: (_guardando || _grupos.isEmpty) ? null : _crearReunion,
              icon: _guardando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add),
              label: Text(_guardando ? 'Guardando...' : 'Crear reunión'),
            ),
          ],
        ),
      ),
    );
  }
}
