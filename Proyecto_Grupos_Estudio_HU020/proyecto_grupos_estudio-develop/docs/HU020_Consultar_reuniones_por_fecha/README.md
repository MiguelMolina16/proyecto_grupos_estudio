# HU020 - Consultar reuniones por fecha

## Descripción
Como estudiante quiero consultar las reuniones de un grupo por fecha o rango de fechas, para encontrar reuniones realizadas en un período determinado.

## Cambios incluidos
- `backend/src/main/java/co/gerard/grupoestudio/rest/ReunionResource.java`: endpoint GET `/kick/reuniones/buscar` con validación de grupo, fechas y orden cronológico.
- `frontend/lib/widgets/utilapi/ServiciosGestion.dart`: método `getReunionesPorFecha` para consultar el endpoint.
- `frontend/lib/widgets/consultar_reuniones_fecha.dart`: pantalla para seleccionar grupo, fecha inicial y fecha final opcional; muestra resultados o mensaje vacío.
- `frontend/lib/main.dart`: se agregó la pestaña para abrir la pantalla HU020.

## Endpoint
`GET /kick/reuniones/buscar?gruId=<UUID>&fechaInicio=AAAA-MM-DD&fechaFin=AAAA-MM-DD`

Para consultar un solo día, enviar la misma fecha en `fechaInicio` y `fechaFin`. La pantalla hace esto automáticamente si no se selecciona fecha final.

## Casos para probar
1. Grupo existente y rango con reuniones: devuelve HTTP 200 y una lista de reuniones ordenadas por fecha y hora.
2. Grupo existente sin reuniones en el rango: devuelve HTTP 200 con `[]`; la interfaz informa que no hay resultados.
3. Fecha inicial posterior a fecha final: devuelve HTTP 400 con un mensaje de validación.
4. Fecha con formato inválido: devuelve HTTP 400.
5. Grupo inexistente: devuelve HTTP 404.
6. Falta el grupo o la fecha inicial: devuelve HTTP 400.

## Ejemplo de consulta
```bash
curl "http://localhost:8620/kick/reuniones/buscar?gruId=UUID_DEL_GRUPO&fechaInicio=2026-10-01&fechaFin=2026-10-31"
```

Reemplaza `UUID_DEL_GRUPO` por el identificador real de un grupo de la base de datos. Si usas el backend desplegado, usa la URL base configurada en `ServiciosGestion.dart`.
