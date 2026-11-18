import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/usuario.dart';

class UsuarioDatabase {
  static final UsuarioDatabase instance = UsuarioDatabase._init();
  static Database? _database;
  UsuarioDatabase._init();

  //obtener la conexion a la base de datos
Future<Database> get database async{
  if (_database != null) return _database!;

  _database = await
  _initDB('usuario.db');
  return _database!;
}
//Iniciar la base de datos

Future<Database> _initDB(String fileName) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, fileName);
  return await openDatabase(path, version: 1, onCreate: _crearTablas,);
}
//Crear tabla de usuarios
Future<void> _crearTablas(Database db, int version) async {
  await db.execute('''CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, apellido_paterno TEXT NOT NULL, apellido_materno TEXT NOT NULL,
   telefono TEXT NOT NULL, correo TEXT NOT NULL, numero_control TEXT NOT NULL UNIQUE)''' );}
  //INSERTAR USUARIO
  Future<bool> insertarUsuario(Usuario usuario)
  async {
    final db = await instance.database;

    //Verificar numero de control duplicado
    final existente = await db.query('usuarios', where: 'numero_control = ?', whereArgs: [usuario.numeroControl.trim()],);
    if(existente.isNotEmpty){
      return false;
    }
    final datos = usuario.toMap();
    datos.remove('id');
    datos['telefono'] = usuario.telefono.trim();
    datos['numero_control'] = usuario.numeroControl.trim();

    await db.insert('usuarios', datos);
    return true;
  }
  //CONSULTAR TODOS LOS USUARIOS

  Future<List<Usuario>>
  obtenerUsuarios() async {
    final db = await instance.database;

    final resultado = await db.query('usuarios', orderBy: 'apellido_paterno ASC',);
    return resultado.map((map) => Usuario.fromMap(map)).toList();
  }
  //ACTUALIZAR USUARIO
  Future<bool> actualizarUsuario(Usuario usuario)
  async {
    final db = await instance.database;

    if (usuario.id ==null) return false;

    //comprobar que el numero de control no pertenezca a otro usuario

    final existente = await db.query('usuarios', where: 'numero_control = ? AND id != ?', whereArgs:
    [usuario.numeroControl.trim(), usuario.id],);

    if (existente.isNotEmpty){
      return false;
    }
    final datos = usuario.toMap();
    datos.remove('id');
    datos['telefono'] = usuario.telefono.trim();
    datos['numero_control'] = usuario.numeroControl.trim();

    final filas = await db.update('usuarios', datos, where: 'id = ?', whereArgs: [usuario.id],);
    return filas> 0;
  }
  //ELIMINAR USUARIO
  Future<int> eliminarUsuario(int id) async{
    final db = await instance.database;

    return await db.delete('usuarios', where: 'id = ?', whereArgs: [id],);
  }
  //BUSCAR USUARIOS CON SELECT LIKE
  Future<List<Usuario>> buscarUsuariosLike(String texto) async{
    final db =await instance.database;

    final busqueda = texto.trim().toUpperCase();

    if (busqueda.isEmpty){
      return obtenerUsuarios();
    }
    final resultado = await db.query('usuarios', where: '''apellido_paterno LIKE ? OR apellido_materno LIKE ? OR telefono LIKE ? OR
    correo LIKE ? OR numero_control Like ?''', whereArgs: List.filled(5, '%$busqueda%'),);
  return resultado.map((map) => Usuario.fromMap(map)).toList();
  }
  //BUSCAR USUARIOS UTILIZANDO CONTAINS
  Future<List<Usuario>> buscarUsuariosContains(String texto) async{
    final usuarios = await obtenerUsuarios();

    final busqueda = texto.trim().toUpperCase();
    if(busqueda.isEmpty){
      return usuarios;
    }
    return usuarios.where((usuario){
      return usuario.apellidoPaterno.toUpperCase().contains(busqueda)||
      usuario.apellidoMaterno.toUpperCase().contains(busqueda)||
      usuario.telefono.contains(busqueda)||
      usuario.correo.toUpperCase().contains(busqueda)||
      usuario.numeroControl.contains(busqueda);
    }).toList();
  }
  //CERRAR BASE DE DATOS
  Future<void> cerrarBaseDatos() async {
    if (_database != null){
      await _database!.close();
      _database=null;
    }
  }
}
