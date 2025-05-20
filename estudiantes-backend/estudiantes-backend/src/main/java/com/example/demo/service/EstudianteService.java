package com.example.demo.service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

import org.springframework.stereotype.Service;

import com.example.demo.model.Estudiante;

@Service
public class EstudianteService {
    
    private final List<Estudiante> estudiantes = new ArrayList<>();
    private final AtomicLong counter = new AtomicLong();
    
    public EstudianteService() {
        // Añadir algunos datos de ejemplo sin llamar a métodos sobreescribibles
        estudiantes.add(new Estudiante(counter.incrementAndGet(), "Juan", "Pérez", 20, "Informática"));
        estudiantes.add(new Estudiante(counter.incrementAndGet(), "María", "López", 21, "Matemáticas"));
        estudiantes.add(new Estudiante(counter.incrementAndGet(), "Carlos", "Gómez", 19, "Física"));
    }
    
    public List<Estudiante> getAllEstudiantes() {
        return estudiantes;
    }
    
    public Estudiante getEstudianteById(Long id) {
        return estudiantes.stream()
                .filter(estudiante -> estudiante.getId().equals(id))
                .findFirst()
                .orElse(null);
    }
    
    public Estudiante addEstudiante(Estudiante estudiante) {
        estudiante.setId(counter.incrementAndGet());
        estudiantes.add(estudiante);
        return estudiante;
    }
    
    public Estudiante updateEstudiante(Long id, Estudiante estudianteDetails) {
        for (int i = 0; i < estudiantes.size(); i++) {
            Estudiante estudiante = estudiantes.get(i);
            if (estudiante.getId().equals(id)) {
                estudianteDetails.setId(id);
                estudiantes.set(i, estudianteDetails);
                return estudianteDetails;
            }
        }
        return null;
    }
    
    public boolean deleteEstudiante(Long id) {
        return estudiantes.removeIf(estudiante -> estudiante.getId().equals(id));
    }
}