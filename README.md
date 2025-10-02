# First1-term-exam---Practical
Proyecto: API FastAPI + Sistema de Login (lab educativo)

Descripción breve
API REST construida con FastAPI para aprender sobre gestión de usuarios y autenticación en un entorno de desarrollo. Incluye endpoints CRUD básicos, un login simple y un script de prueba controlada de fuerza bruta (solo para laboratorio/local). Ideal para practicar seguridad, hashing de contraseñas y mitigaciones.

Nota: todo esto es solo para uso local/lab. No lo despliegues en producción sin las medidas de seguridad correspondientes.

✨ Características principales

FastAPI: framework moderno y rápido para APIs.

Endpoints CRUD para usuarios (crear, leer, actualizar, eliminar).

Endpoint de POST /login para autenticación básica.

Documentación automática con Swagger UI (/docs).

Base de datos “quemada” en código (in-memory) para pruebas rápidas.

Scripts para pruebas de fuerza bruta desde Git Bash (controladas y seguras).

Ejemplos de cuentas de prueba embebidas:

mateo (usuario de desarrollo).

Pipo@example.com
.

📦 Endpoints disponibles (resumen)

POST /usuarios — Crear usuario

GET /listUsers — Listar usuarios

GET /userID/{id} — Obtener usuario por id

PUT /insertUser/{id} — Actualizar usuario

DELETE /deleteUser/{id} — Eliminar usuario

POST /login — Autenticación

(Adapta rutas y nombres según tu main.py si difieren.)

🛠️ Requisitos

Python 3.8+

pip

Git Bash (recomendado para correr los scripts bash; en Windows también puedes usar WSL)
