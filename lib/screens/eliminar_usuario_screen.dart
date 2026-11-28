import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class EliminarUsuarioScreen extends StatefulWidget {
  const EliminarUsuarioScreen({super.key});

  @override
  State<EliminarUsuarioScreen> createState() =>
      _EliminarUsuarioScreenState();
}

class _EliminarUsuarioScreenState extends State<EliminarUsuarioScreen> {

  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL',
    defaultValue: 'http://localhost:5152',);
  List<Usuario> usuarios = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  Future<void> cargarUsuarios() async {
    setState(() {
      cargando = true;
    });
    try {
      final url = Uri.parse('$apiBaseUrl/api/usuarios');
      final respuesta = await http.get(url);

      if (respuesta.statusCode != 200) {
        throw Exception('Error HTTP: ${respuesta.statusCode}');
      }
      final datos = jsonDecode(utf8.decode(respuesta.bodyBytes),
      ) as List<dynamic>;

      final resultado = datos.map((item) =>
          Usuario.fromJson(item as Map<String, dynamic>,)).toList();

      if (!mounted) return;

      setState(() {
        usuarios = resultado;
        cargando = false;
      });
    } catch (e) {
      if
      (!mounted) return;
       setState(() {
         cargando = false;
       });
      ScaffoldMessenger
          .of(context
      ).showSnackBar
        (
        SnackBar
          (content: Text('Error al cargar usuarios:$e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Future<void> confirmarEliminacion(Usuario usuario) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar usuario'),
        content: Text(
          '¿Estás seguro de eliminar a '
              '${usuario.apellidoPaterno} ${usuario.apellidoMaterno} '
              'con número de control ${usuario.numeroControl}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

   final id = usuario.id;
   if (id == null) return;

   final url = Uri.parse('$apiBaseUrl/api/usuarios/$id');

   final respuesta = await http.delete(url);
   final resultado = respuesta.statusCode == 200 ? 1 :0;

    if (!mounted) return;

    if (resultado > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario eliminado correctamente'),
        ),
      );

      await cargarUsuarios();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo eliminar el usuario'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eliminar usuarios'),
        centerTitle: true,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : usuarios.isEmpty
          ? const Center(
        child: Text('No hay usuarios registrados'),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];

          return Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(
                '${usuario.apellidoPaterno} '
                    '${usuario.apellidoMaterno}',
              ),
              subtitle: Text(
                'Control: ${usuario.numeroControl}\n'
                    'Correo: ${usuario.correo}\n'
                    'Teléfono: ${usuario.telefono}',
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                tooltip: 'Eliminar usuario',
                onPressed: () =>
                    confirmarEliminacion(usuario),
              ),
            ),
          );
        },
      ),
    );
  }
}
