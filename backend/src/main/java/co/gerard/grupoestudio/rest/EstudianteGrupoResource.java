package co.gerard.grupoestudio.rest;

import co.gerard.grupoestudio.modelo.relacion.EstudianteGrupo;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.BadRequestException;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import java.util.List;
import java.util.UUID;

@Path("/estudiantes-grupos")
public class EstudianteGrupoResource {

    @GET
    public List<EstudianteGrupo> listar() {
        return EstudianteGrupo.listAll();
    }

    @GET
    @Path("/grupo/{gruId}")
    public List<EstudianteGrupo> porGrupo(@PathParam("gruId") UUID gruId) {
        return EstudianteGrupo.buscarPorGrupo(gruId);
    }

    @GET
    @Path("/estudiante/{estId}")
    public List<EstudianteGrupo> porEstudiante(@PathParam("estId") UUID estId) {
        return EstudianteGrupo.buscarPorEstudiante(estId);
    }

    @POST
    @Transactional
    public EstudianteGrupo crear(EstudianteGrupo eg) {
        if (eg.estId == null || eg.gruId == null) {
            throw new BadRequestException("estId y gruId son obligatorios");
        }
        EstudianteGrupo existente = EstudianteGrupo.buscarPorId(eg.estId, eg.gruId);
        if (existente != null) {
            throw new BadRequestException("El estudiante ya está asignado a ese grupo");
        }
        eg.persist();
        return eg;
    }
}