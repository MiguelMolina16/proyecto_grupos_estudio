\# HU005 - Registrar asistencia a reunión



\## Descripción

Como estudiante quiero registrar la asistencia de uno o varios integrantes a una reunión seleccionada, para mantener el registro y permitir la actualización automática de estadísticas.



\## Criterios de aceptación

\- Seleccionar reunión y mostrar integrantes del grupo.

\- Seleccionar integrantes que asistieron.

\- Validar pertenencia al grupo.

\- Evitar duplicados.

\- Guardar asistencias válidas.

\- Generar evento "Asistencia registrada".

\- Informar errores si ocurren.



\## Implementación

\- Backend: `backend/src/main/java/co/gerard/grupoestudio/`

\- Frontend: `frontend/lib/widgets/asistencia.dart`

\- Tabla PostgreSQL: `asistencias`



\## Endpoints

\- `GET /kick/asistencias` - Listar todas las asistencias

\- `GET /kick/asistencias/{id}` - Obtener una asistencia

\- `GET /kick/asistencias/reunion/{reuId}/integrantes` - Integrantes de una reunión

\- `POST /kick/asistencias` - Registrar asistencia masiva

