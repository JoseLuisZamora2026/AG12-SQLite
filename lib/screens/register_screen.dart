
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/usuario.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _apellidoPaternoController = TextEditingController();
  final _apellidoMaternoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();
  final _numeroControlController = TextEditingController();

  // Validar apellidos
  String? validarApellido(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }

    if (!RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$")
        .hasMatch(value.trim())) {
      return 'Solo se permiten letras y espacios';
    }

    return null;
  }

  // Validar teléfono
  String? validarTelefono(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu teléfono';
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'El teléfono debe tener 10 dígitos';
    }

    return null;
  }

  // Validar correo
  String? validarCorreo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa tu correo electrónico';
    }

    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$')
        .hasMatch(value.trim())) {
      return 'Ingresa un correo válido';
    }

    return null;
  }

  // Validar número de control
  String? validarNumeroControl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa tu número de control';
    }

    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value.trim())) {
      return 'Solo se permiten letras y números';
    }

    return null;
  }

  // Preparar los datos del usuario
  Usuario obtenerUsuario() {
    return Usuario(
      apellidoPaterno:
      _apellidoPaternoController.text.trim().toUpperCase(),
      apellidoMaterno:
      _apellidoMaternoController.text.trim().toUpperCase(),
      telefono: _telefonoController.text.trim(),
      correo: _correoController.text.trim().toUpperCase(),
      numeroControl:
      _numeroControlController.text.trim().toUpperCase(),
    );
  }

  // Validar formulario
  void registrar() {
    if (_formKey.currentState!.validate()) {
      final Usuario usuario = obtenerUsuario();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Datos validados'),
          content: Text(
            'Apellido paterno: ${usuario.apellidoPaterno}\n'
                'Apellido materno: ${usuario.apellidoMaterno}\n'
                'Teléfono: ${usuario.telefono}\n'
                'Correo: ${usuario.correo}\n'
                'Número de control: ${usuario.numeroControl}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ACEPTAR'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _apellidoPaternoController.dispose();
    _apellidoMaternoController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _numeroControlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.person_add_alt_1,
                size: 75,
                color: Colors.blue,
              ),

              const SizedBox(height: 15),

              const Text(
                'Formulario de registro',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              // Apellido paterno
              TextFormField(
                controller: _apellidoPaternoController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Apellido paterno',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: validarApellido,
              ),

              const SizedBox(height: 15),

              // Apellido materno
              TextFormField(
                controller: _apellidoMaternoController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Apellido materno',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: validarApellido,
              ),

              const SizedBox(height: 15),

              // Teléfono
              TextFormField(
                controller: _telefonoController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: validarTelefono,
              ),

              const SizedBox(height: 15),

              // Correo electrónico
              TextFormField(
                controller: _correoController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: validarCorreo,
              ),

              const SizedBox(height: 15),

              // Número de control
              TextFormField(
                controller: _numeroControlController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Número de control',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                validator: validarNumeroControl,
              ),

              const SizedBox(height: 25),

              // Botón registrar
              ElevatedButton(
                onPressed: registrar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'REGISTRAR',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
