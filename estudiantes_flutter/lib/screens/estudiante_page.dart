import 'package:flutter/material.dart';
import '../models/estudiante.dart';
import '../services/estudiante_service.dart';

class EstudiantePage extends StatefulWidget {
  const EstudiantePage({Key? key}) : super(key: key);

  @override
  _EstudiantePageState createState() => _EstudiantePageState();
}

class _EstudiantePageState extends State<EstudiantePage> {
  final EstudianteService _estudianteService = EstudianteService();
  List<Estudiante> _estudiantes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEstudiantes();
  }

  _loadEstudiantes() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final estudiantes = await _estudianteService.getEstudiantes();
      setState(() {
        _estudiantes = estudiantes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar estudiantes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Estudiantes'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _estudiantes.isEmpty
              ? const Center(child: Text('No hay estudiantes registrados'))
              : ListView.builder(
                  itemCount: _estudiantes.length,
                  itemBuilder: (context, index) {
                    final estudiante = _estudiantes[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('${estudiante.nombre} ${estudiante.apellido}'),
                        subtitle: Text('Edad: ${estudiante.edad} - Curso: ${estudiante.curso}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showForm(context, estudiante);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteEstudiante(estudiante);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showForm(context, null);
        },
      ),
    );
  }

  // Mostrar formulario para agregar/editar estudiante
  void _showForm(BuildContext context, Estudiante? estudiante) {
    final _formKey = GlobalKey<FormState>();
    final _nombreController = TextEditingController();
    final _apellidoController = TextEditingController();
    final _edadController = TextEditingController();
    final _cursoController = TextEditingController();

    if (estudiante != null) {
      // Modo edición
      _nombreController.text = estudiante.nombre;
      _apellidoController.text = estudiante.apellido;
      _edadController.text = estudiante.edad.toString();
      _cursoController.text = estudiante.curso;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  estudiante == null ? 'Agregar Estudiante' : 'Editar Estudiante',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _apellidoController,
                  decoration: const InputDecoration(labelText: 'Apellido'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el apellido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _edadController,
                  decoration: const InputDecoration(labelText: 'Edad'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la edad';
                    }
                    if (int.tryParse(value) == null) {
                      return 'La edad debe ser un número';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cursoController,
                  decoration: const InputDecoration(labelText: 'Curso'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el curso';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: Text(estudiante == null ? 'Agregar' : 'Actualizar'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      
                      final newEstudiante = Estudiante(
                        id: estudiante?.id,
                        nombre: _nombreController.text,
                        apellido: _apellidoController.text,
                        edad: int.parse(_edadController.text),
                        curso: _cursoController.text,
                      );
                      
                      try {
                        if (estudiante == null) {
                          // Crear nuevo estudiante
                          await _estudianteService.createEstudiante(newEstudiante);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Estudiante agregado exitosamente')),
                          );
                        } else {
                          // Actualizar estudiante existente
                          await _estudianteService.updateEstudiante(newEstudiante);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Estudiante actualizado exitosamente')),
                          );
                        }
                        
                        _loadEstudiantes(); // Recargar la lista
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Eliminar estudiante
  void _deleteEstudiante(Estudiante estudiante) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Está seguro que desea eliminar a ${estudiante.nombre} ${estudiante.apellido}?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _estudianteService.deleteEstudiante(estudiante.id!);
                  _loadEstudiantes(); // Recargar la lista
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Estudiante eliminado exitosamente')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar estudiante: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}