package co.gerard.grupoestudio.rest;

import co.gerard.grupoestudio.modelo.asistencia.Asistencia;
import co.gerard.grupoestudio.modelo.reunion.Reunion;
import co.gerard.grupoestudio.modelo.tarea.Tarea;
import co.gerard.grupoestudio.modelo.usuario.Usuario;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.NotFoundException;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Path("/estadisticas")
public class EstadisticaResource {

    @GET
    @Path("/{gruId}/{usuId}")
    @Produces(MediaType.APPLICATION_JSON)
    public Map<String, Object> obtenerEstadisticas(
            @PathParam("gruId") UUID gruId,
            @PathParam("usuId") UUID usuId) {

        Usuario usuario = Usuario.findById(usuId);
        if (usuario == null) throw new NotFoundException("Usuario no encontrado");

        // 1. Obtener todas las reuniones del grupo
        List<Reunion> reuniones = Reunion.list("gruId", gruId);
        int totalReuniones = reuniones.size();

        // 2. Contar asistencias del usuario a esas reuniones
        int asistencias = 0;
        for (Reunion r : reuniones) {
            long count = Asistencia.count("reuId = ?1 and usuId = ?2", r.reuId, usuId);
            if (count > 0) {
                asistencias++;
            }
        }

        // 3. Calcular porcentaje de asistencia
        double porcentajeAsistencia = totalReuniones == 0 ? 0.0
                : (asistencias * 100.0) / totalReuniones;

        // 4. Tareas asignadas al usuario en reuniones de este grupo
        long totalTareas = 0;
        long tareasCompletadas = 0;
        for (Reunion r : reuniones) {
            totalTareas += Tarea.count("reuId = ?1 and usuId = ?2", r.reuId, usuId);
            tareasCompletadas += Tarea.count("reuId = ?1 and usuId = ?2 and tarCompletada = true", r.reuId, usuId);
        }

        // 5. Calcular porcentaje de tareas
        double porcentajeTareas = totalTareas == 0 ? 0.0
                : (tareasCompletadas * 100.0) / totalTareas;

        // 6. Construir respuesta JSON
        Map<String, Object> response = new HashMap<>();
        response.put("usuId", usuario.usuId);
        response.put("usuNombres", usuario.usuNombres);
        response.put("usuApellidos", usuario.usuApellidos);
        response.put("totalReuniones", totalReuniones);
        response.put("asistencias", asistencias);
        response.put("porcentajeAsistencia", Math.round(porcentajeAsistencia * 100.0) / 100.0);
        response.put("totalTareas", totalTareas);
        response.put("tareasCompletadas", tareasCompletadas);
        response.put("porcentajeTareas", Math.round(porcentajeTareas * 100.0) / 100.0);

        return response;
    }
}