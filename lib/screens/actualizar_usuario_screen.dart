import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class ActualizarUsuarioScreen extends StatefulWidget {
  const ActualizarUsuarioScreen({super.key});

  @override
  State<ActualizarUsuarioScreen> createState() =>
      _ActualizarUsuarioScreenState();
}

class _ActualizarUsuarioScreenState
    extends State<ActualizarUsuarioScreen> {
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL',
    defaultValue: 'http://localhost:5152',);
  List<Usuario> usuarios = [];
  Usuario? seleccionado;

  final _formKey = GlobalKey<FormState>();

  final paternoController = TextEditingController();
  final maternoController = TextEditingController();
  final telefonoController = TextEditingController();
  final correoController = TextEditingController();
  final controlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  @override
  void dispose() {
    paternoController.dispose();
    maternoController.dispose();
    telefonoController.dispose();
    correoController.dispose();
    controlController.dispose();
    super.dispose();
  }

  Future<void> cargarUsuarios() async {
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
      });
    } catch (e) {
      if
      (
      !
      mounted
      )
        return;

      ScaffoldMessenger
          .
      of
        (
          context
      )
          .
      showSnackBar
        (
        SnackBar
          (
          content
              :
          Text
            (
              'Error al cargar usuarios:$e'
          )
          ,
          backgroundColor
              :
          Colors.red
          ,
        )
        ,
      );
    }
  }

  void seleccionarUsuario(Usuario usuario) {
    setState(() {
      seleccionado = usuario;
      paternoController.text = usuario.apellidoPaterno;
      maternoController.text = usuario.apellidoMaterno;
      telefonoController.text = usuario.telefono;
      correoController.text = usuario.correo;
      controlController.text = usuario.numeroControl;
    });
  }

  Future<void> guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;
    if (seleccionado == null) return;

    final usuario = Usuario(
      id: seleccionado!.id,
      apellidoPaterno: paternoController.text.trim().toUpperCase(),
      apellidoMaterno: maternoController.text.trim().toUpperCase(),
      telefono: telefonoController.text.trim(),
      correo: correoController.text.trim().toUpperCase(),
      numeroControl: controlController.text.trim().toUpperCase(),
    );
    final id = seleccionado!.id;
    if(id == null) return;
    bool actualizado = false;
    try{
      final url = Uri.parse('$apiBaseUrl/api/usuarios/$id');

      final respuesta = await http.put(url, headers: {'Content-Type': 'application/json'},
body: jsonEncode(usuario.toJson()),
);
      if(respuesta.statusCode == 200){
      actualizado = true;
      } else{
        throw Exception('Error HTTP: ${respuesta.statusCode}');
      }
    }catch (e){
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar usuario: $e'),
      backgroundColor: Colors.red,),
      );
      return;
    }

    if (!mounted) return;

    if (actualizado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario actualizado correctamente'),
        ),
      );

      setState(() {
        seleccionado = null;
      });

      await cargarUsuarios();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo actualizar. Verifica el número de control duplicado.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar usuario'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Selecciona un usuario para modificarlo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ...usuarios.map((usuario) => Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                '${usuario.apellidoPaterno} ${usuario.apellidoMaterno}',
              ),
              subtitle: Text(
                'Control: ${usuario.numeroControl}',
              ),
              trailing: const Icon(Icons.edit),
              selected: seleccionado?.id == usuario.id,
              onTap: () => seleccionarUsuario(usuario),
            ),
          )),

          if (seleccionado != null) ...[
            const Divider(height: 30),
            const Text(
              'Modificar información',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  campo(
                    paternoController,
                    'Apellido paterno',
                  ),
                  campo(
                    maternoController,
                    'Apellido materno',
                  ),
                  campo(
                    telefonoController,
                    'Teléfono',
                    tipo: TextInputType.phone,
                    regex: r'^\d{10}$',
                    error: 'Ingresa 10 dígitos',
                  ),
                  campo(
                    correoController,
                    'Correo electrónico',
                    regex: r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    error: 'Correo electrónico no válido',
                  ),
                  campo(
                    controlController,
                    'Número de control',
                    regex: r'^[a-zA-Z0-9]+$',
                    error: 'Usa solamente letras y números',
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: guardarCambios,
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar cambios'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget campo(
      TextEditingController controller,
      String etiqueta, {
        TextInputType tipo = TextInputType.text,
        String? regex,
        String? error,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: tipo,
        decoration: InputDecoration(
          labelText: etiqueta,
          border: const OutlineInputBorder(),
        ),
        validator: (valor) {
          if (valor == null || valor.trim().isEmpty) {
            return 'Este campo es obligatorio';
          }

          if (regex != null &&
              !RegExp(regex).hasMatch(valor.trim())) {
            return error;
          }

          return null;
        },
      ),
    );
  }
}
