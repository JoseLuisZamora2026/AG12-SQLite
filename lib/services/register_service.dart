
import '../database/usuario_database.dart';
import '../models/usuario.dart';

class RegisterService {
  // Registrar un usuario utilizando la base de datos del equipo.
  Future<bool> registrarUsuario(Usuario usuario) async {
    return await UsuarioDatabase.instance.insertarUsuario(usuario);
  }
}
