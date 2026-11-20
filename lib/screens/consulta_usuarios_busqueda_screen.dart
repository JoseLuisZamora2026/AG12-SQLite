import 'package:flutter/material.dart';
import '../database/usuario_database.dart';
import '../models/usuario.dart';

class ConsultaUsuariosBusquedaScreen extends StatefulWidget {
  const ConsultaUsuariosBusquedaScreen({super.key});

  @override
  State<ConsultaUsuariosBusquedaScreen> createState() => _ConsultaUsuariosBusquedaScreenState();
}

class _ConsultaUsuariosBusquedaScreenState extends State<ConsultaUsuariosBusquedaScreen> {
  List<Usuario> _usuarios = [];
  bool _usarLike = true;

  @override
  void initState() {
    super.initState();
    _filtrar('');
  }

  Future<void> _filtrar(String texto) async {
    final res = _usarLike
        ? await UsuarioDatabase.instance.buscarUsuariosLike(texto)
        : await UsuarioDatabase.instance.buscarUsuariosContains(texto);
    setState(() => _usuarios = res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consulta y Búsqueda ')),
      body: Column(
        children: [
          SwitchListTile(
            title: Text(_usarLike ? 'Método: SELECT LIKE (BD)' : 'Método: .contains() (Memoria)'),
            value: _usarLike,
            onChanged: (v) => setState(() {
              _usarLike = v;
              _filtrar('');
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar usuario',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filtrar,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _usuarios.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text('${_usuarios[i].apellidoPaterno} ${_usuarios[i].apellidoMaterno}'),
                subtitle: Text('Control: ${_usuarios[i].numeroControl} | Correo: ${_usuarios[i].correo}'),
                trailing: Text(_usuarios[i].telefono),
              ),
            ),
          ),
        ],
      ),
    );
  }
}