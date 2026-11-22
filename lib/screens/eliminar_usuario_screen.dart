
import 'package:flutter/material.dart';
import '../database/usuario_database.dart';
import '../models/usuario.dart';

class EliminarUsuarioScreen extends StatefulWidget {
  const EliminarUsuarioScreen({super.key});

  @override
  State<EliminarUsuarioScreen> createState() =>
      _EliminarUsuarioScreenState();
}

class _EliminarUsuarioScreenState extends State<EliminarUsuarioScreen> {
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

    final resultado =
    await UsuarioDatabase.instance.obtenerUsuarios();

    if (!mounted) return;

    setState(() {
      usuarios = resultado;
      cargando = false;
    });
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

    final resultado =
    await UsuarioDatabase.instance.eliminarUsuario(usuario.id!);

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
