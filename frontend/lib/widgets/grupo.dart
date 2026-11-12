import 'package:flutter/material.dart';
import '../modelos/grupo.dart';
import 'utilapi/ServiciosGestion.dart';

class GrupoWidget extends StatefulWidget {
  const GrupoWidget({super.key});

  @override
  State<GrupoWidget> createState() => _GrupoWidgetState();
}

class _GrupoWidgetState extends State<GrupoWidget> {
  final ServiciosGestion _api = ServiciosGestion();

  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _descripcionCtrl = TextEditingController();

  List<Grupo> _grupos = [];
  bool _cargando = true;
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _cargarGrupos();
  }

  Future<void> _cargarGrupos() async {
    try {
      final lista = await _api.getGrupos();
      setState(() {
        _grupos = lista;
        _cargando = false;
      });
    } catch (e) {
      setState(() => _cargando = false);
      _msg('Error al cargar grupos: $e', false);
    }
  }

  Future<void> _crearGrupo() async {
    // Validar nombre
    if (_nombreCtrl.text.trim().isEmpty) {
      _msg('El nombre del grupo es obligatorio', false);
      return;
    }
    // Validar descripción
    if (_descripcionCtrl.text.trim().isEmpty) {
      _msg('La descripción del grupo es obligatoria', false);
      return;
    }

    setState(() => _enviando = true);
    try {
      final res = await _api.crearGrupo(
        _nombreCtrl.text.trim(),
        _descripcionCtrl.text.trim(),
      );
      if (res == 'OK') {
        _msg('Grupo creado correctamente', true);
        _nombreCtrl.clear();
        _descripcionCtrl.clear();
        await _cargarGrupos();
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Crear nuevo grupo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nombreCtrl,
            decoration: const InputDecoration(
              labelText: 'Nombre del grupo',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descripcionCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _enviando ? null : _crearGrupo,
            icon: _enviando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: Text(_enviando ? 'Guardando...' : 'Crear grupo'),
          ),
          const SizedBox(height: 32),
          const Text(
            'Grupos existentes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_cargando)
            const Center(child: CircularProgressIndicator())
          else if (_grupos.isEmpty)
            const Center(child: Text('No hay grupos registrados'))
          else
            ..._grupos.map((g) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.group),
                    title: Text(g.gruNombre),
                    subtitle: Text(g.gruDescripcion),
                  ),
                )),
        ],
      ),
    );
  }
}