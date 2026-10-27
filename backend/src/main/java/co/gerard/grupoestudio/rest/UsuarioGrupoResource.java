package co.gerard.grupoestudio.rest;

import co.gerard.grupoestudio.modelo.relacion.UsuarioGrupo;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.BadRequestException;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import java.util.List;
import java.util.UUID;

@Path("/usuarios-grupos")
public class UsuarioGrupoResource {

    @GET
    public List<UsuarioGrupo> listar() {
        return UsuarioGrupo.listAll();
    }

    @GET
    @Path("/grupo/{gruId}")
    public List<UsuarioGrupo> porGrupo(@PathParam("gruId") UUID gruId) {
        return UsuarioGrupo.buscarPorGrupo(gruId);
    }

    @GET
    @Path("/usuario/{usuId}")
    public List<UsuarioGrupo> porUsuario(@PathParam("usuId") UUID usuId) {
        return UsuarioGrupo.buscarPorUsuario(usuId);
    }

    @POST
    @Transactional
    public UsuarioGrupo crear(UsuarioGrupo ug) {
        if (ug.usuId == null || ug.gruId == null) {
            throw new BadRequestException("usuId y gruId son obligatorios");
        }
        UsuarioGrupo existente = UsuarioGrupo.buscarPorId(ug.usuId, ug.gruId);
        if (existente != null) {
            throw new BadRequestException("El usuario ya está asignado a ese grupo");
        }
        ug.persist();
        return ug;
    }
}