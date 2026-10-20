# HU028 - Gestión de tareas y consulta de estadísticas

## Descripción
Como docente, quiero registrar y gestionar tareas asignadas a los integrantes en cada reunión, así como consultar sus estadísticas de participación (asistencia y cumplimiento de tareas) dentro de un grupo de estudio.

## Criterios de aceptación
- [x] Registro de tareas (individual y masiva).
- [x] Gestión de estado (marcar completada/pendiente).
- [x] Selección de grupo y luego integrante para consulta.
- [x] Visualización de asistencia (total, asistencias, %).
- [x] Visualización de tareas (total, completadas, %).
- [x] Manejo de vacíos (0% y mensajes si no hay datos).

## Implementación
- **Backend:** Entidad `Tarea.java`, DTO `TareaRequest.java`, `TareaResource.java`, `EstadisticaResource.java`.
- **Frontend:** `estadisticas_tareas.dart`, `tarea.dart`, `estadistica.dart`.
- **Base de datos:** Tabla `tareas` en Supabase.

## Pruebas realizadas
- Creación de tarea individual y para todo el grupo.
- Cambio de estado (completada/pendiente) y actualización de porcentajes en tiempo real.
- Persistencia verificada en Supabase.