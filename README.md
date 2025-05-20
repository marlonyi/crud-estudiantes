# CRUD Estudiantes 📚

Este proyecto es una aplicación de CRUD para estudiantes, desarrollado con:

- **Frontend:** Flutter 🐦
- **Backend:** Spring Boot ☕ (sin base de datos, usando lista en memoria)

---

## 🚀 Cómo ejecutar el proyecto

### 🔧 Backend - Spring Boot

1. Requisitos:
   - Java 17 o superior
   - Maven

2. Instrucciones:
   - Abre una terminal y navega a la carpeta:

     ```bash
     cd estudiantes-backend
     ```

   - Ejecuta el backend:

     ```bash
     ./mvnw spring-boot:run
     ```

   - El backend se ejecutará en:  
     `http://localhost:8080/api/estudiantes`

---

### 💻 Frontend - Flutter

1. Requisitos:
   - Flutter SDK instalado

2. Instrucciones:
   - Abre otra terminal y navega a la carpeta:

     ```bash
     cd estudiantes_flutter
     ```

   - Ejecuta el proyecto en un emulador o dispositivo:

     ```bash
     flutter run
     ```

   - Asegúrate de que la IP del backend esté bien configurada en `estudiante_service.dart`.

---

## 📁 Estructura del proyecto

crud-estudiantes/
│
├── estudiantes_flutter/ # Aplicación Flutter (frontend)
│
├── estudiantes-backend/ # API Java Spring Boot (backend)
│
└── README.md # Este archivo

yaml
Copiar
Editar

---

## 🛠️ Autor

- Proyecto desarrollado por [Marlon Yi] 💻
