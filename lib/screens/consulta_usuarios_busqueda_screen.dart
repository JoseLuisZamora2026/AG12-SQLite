import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:5152',);
  Future<void> _filtrar(String texto)
  async{
    try{
      final termino = texto.trim();
      Uri url;

      if (termino.isEmpty || ! _usarLike) {
        url = Uri.parse('$apiBaseUrl/api/usuarios');
      }else{
        url = Uri.parse('$apiBaseUrl/api/usuarios/buscar') .replace(queryParameters: {'termino': termino});
      }
      final respuesta = await http.get(url);
      if (respuesta.statusCode != 200)
        {
          throw Exception('Error HTTP: ${respuesta.statusCode}');
        }
      final datos = jsonDecode(utf8.decode(respuesta.bodyBytes),
      ) as List<dynamic>;

      List<Usuario> resultados = datos.map((item) =>Usuario.fromJson(item as Map<String, dynamic>)).toList();

      if (!_usarLike && termino.isNotEmpty) {
        final busqueda = termino.toUpperCase();

        resultados = resultados.where((usuario) {
          return usuario.apellidoPaterno.toUpperCase().contains(busqueda) || usuario.apellidoMaterno.toUpperCase().contains(busqueda) ||
    usuario.numeroControl.toUpperCase().contains(busqueda);
    }).toList();
    }

      if (!mounted) return;

      setState(() {
        _usuarios = resultados;
      });
    } catch (e){
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al consultar usuarios: $e'),
      backgroundColor: Colors.red,
      ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consulta y Búsqueda ')),
      body: Column(
        children: [
          SwitchListTile(
            title: Text(_usarLike ? 'Método: SELECT LIKE (MySQL)' : 'Método: .contains() (Memoria)'),
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