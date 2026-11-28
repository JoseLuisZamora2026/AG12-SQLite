import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class RegisterService {
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:5152');

  //registrar usuario en MySQL mediante la API

Future<bool> registrarUsuario(Usuario usuario) async{
  final url = Uri.parse('$apiBaseUrl/api/usuarios');

  final respuesta = await http.post(url, headers: {
    'Content-Type': 'application/json',
  },
  body: jsonEncode(usuario.toJson()),
  );

  if (respuesta.statusCode == 201)
    {
      return true;
    }

  if(respuesta.statusCode ==409)
    {
      return false;
    }
  throw Exception('Error al registrar usuario: ${respuesta.statusCode} '
  '${respuesta.body}'
  );
}
}