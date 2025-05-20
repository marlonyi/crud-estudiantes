class Estudiante {
  int? id;
  String nombre;
  String apellido;
  int edad;
  String curso;

  Estudiante({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.edad,
    required this.curso,
  });

  factory Estudiante.fromJson(Map<String, dynamic> json) {
    return Estudiante(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      edad: json['edad'],
      curso: json['curso'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'edad': edad,
      'curso': curso,
    };
  }
}