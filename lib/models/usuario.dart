class Usuario {
  final int? id;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String telefono;
  final String correo;
  final String numeroControl;

  Usuario({
    this.id,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.telefono,
    required this.correo,
    required this.numeroControl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'apellido_paterno': apellidoPaterno.toUpperCase(),
      'apellido_materno': apellidoMaterno.toUpperCase(),
      'telefono': telefono,
      'correo': correo.toUpperCase(),
      'numero_control': numeroControl.toUpperCase(),
    };
  }
  Map<String, dynamic> toJson() {
    return{
      'apellidoPaterno': apellidoPaterno.toUpperCase(),
      'apellidoMaterno': apellidoMaterno.toUpperCase(),
      'telefono': telefono.toUpperCase(),
      'correo': correo.toUpperCase(),
      'numeroControl': numeroControl.toUpperCase(),
    };
  }
  factory Usuario.fromJson(Map<String, dynamic>json){
    return Usuario(id: json['id']==null ? null : (json['id'] as num).toInt(),
      apellidoPaterno: json['apellidoPaterno'],
    apellidoMaterno: json['apellidoMaterno'],
    telefono: json['telefono'],
    correo: json['correo'],
    numeroControl: json['numeroControl'],
    );
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      apellidoPaterno: map['apellido_paterno'],
      apellidoMaterno: map['apellido_materno'],
      telefono: map['telefono'],
      correo: map['correo'],
      numeroControl: map['numero_control'],
    );
  }
}