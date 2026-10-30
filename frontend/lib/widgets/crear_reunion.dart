
import 'package:flutter/material.dart';

import '../modelos/grupo.dart';
import 'utilapi/ServiciosGestion.dart';

class CrearReunion extends StatefulWidget {
  const CrearReunion({super.key});

  @override
  State<CrearReunion> createState() => _CrearReunionState();
}

class _CrearReunionState extends State<CrearReunion> {
  final ServiciosGestion _api = ServiciosGestion();
  final _formKey = GlobalKey<FormState>();

  final _localizacionCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();

  List<Grupo> _grupos = [];
  Grupo? _grupoSeleccionado;
  DateTime? _fecha;
  TimeOfDay? _hora;

  bool _cargando = true;
  bool _guardando = false;
  String? _errorCarga;

  @override
  void initState() {
    super.initState();
    _cargarGrupos();
  }

  @override
  void dispose() {
    _localizacionCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarGrupos() async {
    try {
      final grupos = await _api.getGrupos();
      if (!mounted) return;

      setState(() {
        _grupos = grupos.where((g) => g.gruId.isNotEmpty).toList();
        _cargando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _errorCarga = 'No se pudieron cargar los grupos.';
      });
    }
  }

  Future<void> _seleccionarFecha() async {
    final hoy = DateUtils.dateOnly(DateTime.now());
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: _fecha ?? hoy,
      firstDate: hoy,
      lastDate: DateTime(2100),
      helpText: 'Selecciona la fecha de la reunión',
    );

    if (seleccionada != null && mounted) {
      setState(() => _fecha = seleccionada);
    }
  }

  Future<void> _seleccionarHora() async {
    final seleccionada = await showTimePicker(
      context: context,
      initialTime: _hora ?? TimeOfDay.now(),
      helpText: 'Selecciona la hora de la reunión',
    );

    if (seleccionada != null && mounted) {
      setState(() => _hora = seleccionada);
    }
  }

  String _fechaTexto(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  String _horaTexto(TimeOfDay hora) {
    final h = hora.hour.toString().padLeft(2, '0');
    final m = hora.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _mensaje(String texto, bool correcto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor:
            correcto ? Colors.green : const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _crear() async {
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
      final fecha = _fecha!;
      final fechaApi =
          '${fecha.year.toString().padLeft(4, '0')}-'
          '${fecha.month.toString().padLeft(2, '0')}-'
          '${fecha.day.toString().padLeft(2, '0')}';

      final resultado = await _api.crearReunion(
        gruId: _grupoSeleccionado!.gruId,
        fecha: fechaApi,
        hora: _horaTexto(_hora!),
        localizacion: _localizacionCtrl.text.trim(),
        descripcion: _descripcionCtrl.text.trim(),
      );

      if (!mounted) return;

      if (resultado == 'OK') {
        _mensaje('Reunión creada correctamente.', true);
        setState(() {
          _grupoSeleccionado = null;
          _fecha = null;
          _hora = null;
          _localizacionCtrl.clear();
          _descripcionCtrl.clear();
        });
      } else {
        _mensaje(resultado, false);
      }
    } catch (_) {
      if (mounted) {
        _mensaje('Ocurrió un error al crear la reunión.', false);
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorCarga != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_errorCarga!),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _cargando = true;
                    _errorCarga = null;
                  });
                  _cargarGrupos();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        Icons.event_available_outlined,
                        color: Color(0xFF2563EB),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Crear reunión',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Registra una reunión para tu grupo de estudio.',
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
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Información de la reunión',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<Grupo>(
                          isExpanded: true,
                          value: _grupoSeleccionado,
                          decoration: const InputDecoration(
                            labelText: 'Grupo de estudio',
                            prefixIcon: Icon(Icons.groups_outlined),
                            border: OutlineInputBorder(),
                          ),
                          items: _grupos.map((grupo) {
                            return DropdownMenuItem<Grupo>(
                              value: grupo,
                              child: Text(
                                grupo.gruNombre,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: _guardando
                              ? null
                              : (grupo) {
                                  setState(
                                    () => _grupoSeleccionado = grupo,
                                  );
                                },
                          validator: (grupo) =>
                              grupo == null ? 'Selecciona un grupo' : null,
                        ),
                        if (_grupos.isEmpty) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'No hay grupos disponibles para seleccionar.',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed:
                              _guardando ? null : _seleccionarFecha,
                          icon: const Icon(Icons.calendar_month_outlined),
                          label: Text(
                            _fecha == null
                                ? 'Seleccionar fecha'
                                : 'Fecha: ${_fechaTexto(_fecha!)}',
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed:
                              _guardando ? null : _seleccionarHora,
                          icon: const Icon(Icons.access_time),
                          label: Text(
                            _hora == null
                                ? 'Seleccionar hora'
                                : 'Hora: ${_horaTexto(_hora!)}',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _localizacionCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Lugar o modalidad',
                            hintText: 'Ej. Biblioteca o virtual',
                            prefixIcon: Icon(Icons.location_on_outlined),
                            border: OutlineInputBorder(),
                          ),
                          maxLength: 100,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa el lugar o modalidad';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _descripcionCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Descripción',
                            hintText: 'Describe la actividad de la reunión',
                            prefixIcon: Icon(Icons.description_outlined),
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa una descripción';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _guardando || _grupos.isEmpty
                              ? null
                              : _crear,
                          icon: _guardando
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(
                            _guardando
                                ? 'Creando reunión...'
                                : 'Crear reunión',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
