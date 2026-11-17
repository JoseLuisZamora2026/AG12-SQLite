import 'package:flutter/material.dart';

void main() {
  runApp(const AG12App());
}

class AG12App extends StatelessWidget {
  const AG12App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AG12 - Gestión de Usuarios',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const InicioScreen(),
    );
  }
}

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
      ),
      body: const Center(
        child: Text(
          'AG12 - Bases de datos con SQLite',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}