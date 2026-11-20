
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/usuario.dart';
import '../services/register_service.dart';

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

  bool _registrando = false;

  final RegisterService _registerService = RegisterService();

  // Validar apellidos
  String? validarApellido(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }

    if (!RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$")
        .hasMatch(value.trim())) {
      return 'Solo se permiten letras';
    }

    return null;
  }

  // Validar telefono
  String? validarTelefono(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El teléfono es obligatorio';
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
      return 'Ingresa un teléfono de 10 dígitos';
    }

    return null;
  }

  // Validar correo
  String? validarCorreo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El correo es obligatorio';
    }

    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$')
        .hasMatch(value.trim())) {
      return 'Ingresa un correo válido';
    }

    return null;
  }

  // Validar numero de control
  String? validarNumeroControl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El número de control es obligatorio';
    }

    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value.trim())) {
      return 'Solo se permiten letras y números';
    }

    return null;
  }

  // Registrar usuario en SQLite
  Future<void> registrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final usuario = Usuario(
      apellidoPaterno: _apellidoPaternoController.text.trim().toUpperCase(),
      apellidoMaterno: _apellidoMaternoController.text.trim().toUpperCase(),
      telefono: _telefonoController.text.trim(),
      correo: _correoController.text.trim().toUpperCase(),
      numeroControl: _numeroControlController.text.trim().toUpperCase(),
    );

    setState(() {
      _registrando = true;
    });

    try {
      final resultado =
      await _registerService.registrarUsuario(usuario);

      if (!mounted) return;

      if (resultado) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario registrado correctamente'),
            backgroundColor: Colors.green,
          ),
        );

        _formKey.currentState!.reset();
        _apellidoPaternoController.clear();
        _apellidoMaternoController.clear();
        _telefonoController.clear();
        _correoController.clear();
        _numeroControlController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El número de control ya está registrado'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar usuario: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _registrando = false;
        });
      }
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

              // Telefono
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

              // Correo
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

              // Numero de control
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

              // Boton registrar
              ElevatedButton(
                onPressed: _registrando ? null : registrar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _registrando
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
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
