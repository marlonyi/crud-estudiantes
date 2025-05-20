import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/estudiante.dart';

class EstudianteService {
  final String baseUrl = 'http://192.168.1.21:8080/api/estudiantes'; // Para emulador Android
  // Para dispositivo físico o iOS usar la IP de tu computadora, ejemplo:
  // final String baseUrl = 'http://192.168.1.100:8080/api/estudiantes';

  Future<List<Estudiante>> getEstudiantes() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Estudiante> estudiantes = body.map((item) => Estudiante.fromJson(item)).toList();
      return estudiantes;
    } else {
      throw Exception('Failed to load estudiantes');
    }
  }

  Future<Estudiante> createEstudiante(Estudiante estudiante) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(estudiante.toJson()),
    );

    if (response.statusCode == 201) {
      return Estudiante.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create estudiante');
    }
  }

  Future<Estudiante> updateEstudiante(Estudiante estudiante) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${estudiante.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(estudiante.toJson()),
    );

    if (response.statusCode == 200) {
      return Estudiante.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update estudiante');
    }
  }

  Future<void> deleteEstudiante(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete estudiante');
    }
  }
}