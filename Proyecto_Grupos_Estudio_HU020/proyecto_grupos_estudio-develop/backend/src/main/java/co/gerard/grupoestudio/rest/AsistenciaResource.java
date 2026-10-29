package co.gerard.grupoestudio.rest;

import co.gerard.grupoestudio.dto.AsistenciaMasivaRequest;
import co.gerard.grupoestudio.evento.AsistenciaRegistradaEvent;
import co.gerard.grupoestudio.modelo.asistencia.Asistencia;
import co.gerard.grupoestudio.modelo.usuario.Usuario;
import co.gerard.grupoestudio.modelo.relacion.UsuarioGrupo;
import co.gerard.grupoestudio.modelo.reunion.Reunion;
import jakarta.enterprise.event.Event;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.BadRequestException;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.NotFoundException;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Path("/asistencias")
public class AsistenciaResource {

    @Inject
    Event<AsistenciaRegistradaEvent> eventoAsistencia;

    @GET
    public List<Asistencia> listar() {
        return Asistencia.listAll();
    }

    @GET
    @Path("/{id}")
    public Asistencia getPorId(@PathParam("id") UUID id) {
        Asistencia a = Asistencia.findById(id);
        if (a == null) throw new NotFoundException("Asistencia no encontrada");
        return a;
    }

    @GET
    @Path("/reunion/{reuId}/integrantes")
    public List<Usuario> integrantesDeReunion(@PathParam("reuId") UUID reuId) {
        Reunion reunion = Reunion.findById(reuId);
        if (reunion == null) throw new NotFoundException("Reunión no encontrada");

        List<UsuarioGrupo> relaciones = UsuarioGrupo.buscarPorGrupo(reunion.gruId);
        List<Usuario> integrantes = new ArrayList<>();
        for (UsuarioGrupo ug : relaciones) {
            Usuario u = Usuario.findById(ug.usuId);
            if (u != null) integrantes.add(u);
        }
        return integrantes;
    }

    @POST
    @Transactional
    public List<Asistencia> registrar(AsistenciaMasivaRequest request) {

        if (request.reuId == null) {
            throw new BadRequestException("reuId es obligatorio");
        }
        if (request.usuIds == null || request.usuIds.isEmpty()) {
            throw new BadRequestException("Debe indicar al menos un usuario");
        }

        Reunion reunion = Reunion.findById(request.reuId);
        if (reunion == null) {
            throw new BadRequestException("La reunión no existe");
        }

        List<Asistencia> creadas = new ArrayList<>();
        for (UUID usuId : request.usuIds) {

            Usuario usu = Usuario.findById(usuId);
            if (usu == null) {
                throw new BadRequestException("El usuario " + usuId + " no existe");
            }

            UsuarioGrupo pertenece = UsuarioGrupo.buscarPorId(usuId, reunion.gruId);
            if (pertenece == null) {
                throw new BadRequestException(
                    "El usuario " + usu.usuNombres + " " + usu.usuApellidos +
                    " no pertenece al grupo de esta reunión"
                );
            }

            Asistencia existente = Asistencia.find(
                "reuId = ?1 and usuId = ?2", request.reuId, usuId
            ).firstResult();
            if (existente != null) {
                throw new BadRequestException(
                    "El usuario " + usu.usuNombres + " " + usu.usuApellidos +
                    " ya tiene asistencia registrada en esta reunión"
                );
            }

            Asistencia nueva = new Asistencia();
            nueva.reuId = request.reuId;
            nueva.usuId = usuId;
            nueva.asiCreacion = LocalDateTime.now();
            nueva.persist();
            creadas.add(nueva);
        }

        eventoAsistencia.fire(new AsistenciaRegistradaEvent(request.reuId, request.usuIds));

        return creadas;
    }
}