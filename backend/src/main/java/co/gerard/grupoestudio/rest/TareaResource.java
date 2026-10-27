package co.gerard.grupoestudio.rest;

import co.gerard.grupoestudio.dto.TareaRequest;
import co.gerard.grupoestudio.modelo.reunion.Reunion;
import co.gerard.grupoestudio.modelo.relacion.UsuarioGrupo;
import co.gerard.grupoestudio.modelo.tarea.Tarea;
import co.gerard.grupoestudio.modelo.usuario.Usuario;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Path("/tareas")
public class TareaResource {

    @GET
    @Path("/reunion/{reuId}")
    public List<Tarea> listarPorReunion(@PathParam("reuId") UUID reuId) {
        return Tarea.list("reuId", reuId);
    }

    @POST
    @Transactional
    public Response crearTarea(TareaRequest request) {
        if (request.reuId == null || request.tarDescripcion == null || request.tarDescripcion.trim().isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("error", "La reunión y la descripción son obligatorias"))
                    .type(MediaType.APPLICATION_JSON).build();
        }

        Reunion reunion = Reunion.findById(request.reuId);
        if (reunion == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(Map.of("error", "Reunión no encontrada"))
                    .type(MediaType.APPLICATION_JSON).build();
        }

        // Caso 1: Asignar a un estudiante específico
        if (request.usuId != null) {
            Usuario usuario = Usuario.findById(request.usuId);
            if (usuario == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(Map.of("error", "Usuario no encontrado"))
                        .type(MediaType.APPLICATION_JSON).build();
            }
            Tarea tarea = new Tarea();
            tarea.reuId = request.reuId;
            tarea.usuId = request.usuId;
            tarea.tarDescripcion = request.tarDescripcion;
            tarea.tarCreacion = LocalDateTime.now();
            tarea.persist();
            return Response.status(Response.Status.CREATED).entity(tarea).build();
        }

        // Caso 2: Asignar a TODO el grupo (usuId viene null)
        List<UsuarioGrupo> integrantes = UsuarioGrupo.buscarPorGrupo(reunion.gruId);
        if (integrantes == null || integrantes.isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("error", "El grupo no tiene integrantes"))
                    .type(MediaType.APPLICATION_JSON).build();
        }

        List<Tarea> tareasCreadas = new ArrayList<>();
        for (UsuarioGrupo ug : integrantes) {
            Tarea t = new Tarea();
            t.reuId = request.reuId;
            t.usuId = ug.usuId;
            t.tarDescripcion = request.tarDescripcion;
            t.tarCreacion = LocalDateTime.now();
            t.persist();
            tareasCreadas.add(t);
        }

        return Response.status(Response.Status.CREATED).entity(tareasCreadas).build();
    }

    @PUT
    @Path("/{id}/estado")
    @Transactional
    public Response cambiarEstado(@PathParam("id") UUID id, Map<String, Boolean> body) {
        Tarea tarea = Tarea.findById(id);
        if (tarea == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(Map.of("error", "Tarea no encontrada"))
                    .type(MediaType.APPLICATION_JSON).build();
        }
        if (body.containsKey("completada")) {
            tarea.tarCompletada = body.get("completada");
            return Response.ok(tarea).build();
        }
        return Response.status(Response.Status.BAD_REQUEST)
                .entity(Map.of("error", "Falta el campo 'completada'"))
                .type(MediaType.APPLICATION_JSON).build();
    }
}