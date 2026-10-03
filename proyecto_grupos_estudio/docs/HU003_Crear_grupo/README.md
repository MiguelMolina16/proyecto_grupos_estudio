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

# HU003 - Crear grupo de estudio

## Descripción
Como docente quiero crear un grupo de estudio ingresando su nombre y descripción, para disponer de un espacio organizado donde pueda realizar actividades académicas con otros estudiantes.

## Criterios de aceptación
- [x] Validar que ambos campos estén diligenciados.
- [x] Registrar grupo y mostrarlo en listado.
- [x] Si falta un campo, mostrar mensaje indicando cuál.
- [x] Si ocurre error, informar que no se pudo crear.

## Implementación

### Backend
- `backend/src/main/java/co/gerard/grupoestudio/rest/GrupoResource.java`
  - `GET /kick/grupos` → lista todos los grupos
  - `GET /kick/grupos/{id}` → busca uno por ID
  - `POST /kick/grupos` → crea con validaciones (400 + mensaje específico)

### Frontend
- `frontend/lib/modelos/grupo.dart` → modelo Dart
- `frontend/lib/widgets/grupo.dart` → pantalla con formulario + lista
- `frontend/lib/widgets/utilapi/ServiciosGestion.dart` → métodos `getGrupos()` y `crearGrupo()`
- `frontend/lib/main.dart` → navegación por pestañas (Grupos / Asistencia)

### Base de datos
- Tabla `grupos` en Supabase (ya existente)
- Columnas: `gru_id`, `gru_nombre`, `gru_descripcion`, `gru_creacion`

## Pruebas realizadas
| Caso | Resultado |
|---|---|
| Crear grupo válido | 201 Created + aparece en la lista |
| Falta nombre | 400 + "El nombre del grupo es obligatorio" |
| Falta descripción | 400 + "La descripción del grupo es obligatoria" |
| Ambos vacíos | 400 + mensaje del nombre |
| Persistencia tras recarga | Grupo sigue en la lista |