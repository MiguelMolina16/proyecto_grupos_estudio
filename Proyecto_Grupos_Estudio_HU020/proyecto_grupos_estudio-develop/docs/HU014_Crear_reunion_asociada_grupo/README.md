# HU014 - Crear reunión asociada a grupo

## Cambios incluidos

- Backend: `ReunionResource` valida que el grupo exista, que la fecha esté informada y que lugar/modalidad y descripción no estén vacíos. Devuelve HTTP 201 al crear y mensajes claros en caso de error.
- Frontend: nuevo formulario `frontend/lib/widgets/crear_reunion.dart` para seleccionar grupo, fecha, hora, lugar/modalidad y descripción.
- Servicio: métodos `getGrupos()` y `crearReunion()` en `ServiciosGestion.dart`.
- Navegación: se agregó la pestaña HU014 en `frontend/lib/main.dart`.

## Ejecutar localmente

1. Configura `SUPABASE_PASSWORD` en el entorno del backend, según las instrucciones del proyecto.
2. En `backend`, ejecuta `bash mvnw quarkus:dev` (o `mvnw.cmd quarkus:dev` en Windows).
3. En `frontend`, ejecuta `flutter pub get` y luego `flutter run`.
4. La aplicación utiliza la URL de API que ya estaba configurada en `ServiciosGestion.dart`. Para probar contra un backend local, cambia `apiUrl` a `http://localhost:8620/kick` y asegúrate de que el backend escuche en una interfaz accesible desde el dispositivo/emulador.

## Pruebas funcionales sugeridas

1. Abrir la pestaña “Crear reunión” y comprobar que carga la lista de grupos.
2. Intentar crear sin grupo, fecha, hora, lugar/modalidad o descripción: la aplicación debe pedir completar los campos.
3. Crear una reunión con un grupo existente y todos los datos: debe aparecer el mensaje “Reunión creada correctamente”.
4. Enviar directamente al endpoint `POST /kick/reuniones` un `gruId` inexistente: el backend debe responder HTTP 404.
5. Enviar la petición sin `reuFecha` o sin `gruId`: el backend debe responder HTTP 400.
6. Consultar `GET /kick/reuniones` y comprobar que aparece la reunión recién creada.

Nota: las pruebas automáticas no pudieron ejecutarse en este entorno porque Maven Wrapper no pudo descargar Maven desde Maven Central. Se debe ejecutar la compilación y las pruebas en el equipo del proyecto con conexión disponible.
