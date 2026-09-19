package co.gerard.grupoestudio.rest;

import co.gerard.grupoestudio.dto.AsistenciaMasivaRequest;
import co.gerard.grupoestudio.evento.AsistenciaRegistradaEvent;
import co.gerard.grupoestudio.modelo.asistencia.Asistencia;
import co.gerard.grupoestudio.modelo.estudiante.Estudiante;
import co.gerard.grupoestudio.modelo.relacion.EstudianteGrupo;
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

    /**
     * GET que devuelve los estudiantes que pueden asistir a una reunión
     * (los integrantes del grupo de esa reunión).
     */
    @GET
    @Path("/reunion/{reuId}/integrantes")
    public List<Estudiante> integrantesDeReunion(@PathParam("reuId") UUID reuId) {
        Reunion reunion = Reunion.findById(reuId);
        if (reunion == null) throw new NotFoundException("Reunión no encontrada");

        List<EstudianteGrupo> relaciones = EstudianteGrupo.buscarPorGrupo(reunion.gruId);
        List<Estudiante> integrantes = new ArrayList<>();
        for (EstudianteGrupo eg : relaciones) {
            Estudiante e = Estudiante.findById(eg.estId);
            if (e != null) integrantes.add(e);
        }
        return integrantes;
    }

    /**
     * POST masivo: registra la asistencia de uno o varios integrantes a una reunión.
     */
    @POST
    @Transactional
    public List<Asistencia> registrar(AsistenciaMasivaRequest request) {

        // 1. Validar entrada básica
        if (request.reuId == null) {
            throw new BadRequestException("reuId es obligatorio");
        }
        if (request.estIds == null || request.estIds.isEmpty()) {
            throw new BadRequestException("Debe indicar al menos un estudiante");
        }

        // 2. Verificar que la reunión existe
        Reunion reunion = Reunion.findById(request.reuId);
        if (reunion == null) {
            throw new BadRequestException("La reunión no existe");
        }

        // 3. Validar pertenencia al grupo y duplicados
        List<Asistencia> creadas = new ArrayList<>();
        for (UUID estId : request.estIds) {

            // 3a. Estudiante existe
            Estudiante est = Estudiante.findById(estId);
            if (est == null) {
                throw new BadRequestException("El estudiante " + estId + " no existe");
            }

            // 3b. Pertenencia al grupo de la reunión
            EstudianteGrupo pertenece = EstudianteGrupo.buscarPorId(estId, reunion.gruId);
            if (pertenece == null) {
                throw new BadRequestException(
                    "El estudiante " + est.estNombres + " " + est.estApellidos +
                    " no pertenece al grupo de esta reunión"
                );
            }

            // 3c. Duplicado
            Asistencia existente = Asistencia.find(
                "reuId = ?1 and estId = ?2", request.reuId, estId
            ).firstResult();
            if (existente != null) {
                throw new BadRequestException(
                    "El estudiante " + est.estNombres + " " + est.estApellidos +
                    " ya tiene asistencia registrada en esta reunión"
                );
            }

            // 3d. Crear y persistir
            Asistencia nueva = new Asistencia();
            nueva.reuId = request.reuId;
            nueva.estId = estId;
            nueva.asiCreacion = LocalDateTime.now();
            nueva.persist();
            creadas.add(nueva);
        }

        // 4. Disparar evento "Asistencia registrada"
        eventoAsistencia.fire(new AsistenciaRegistradaEvent(request.reuId, request.estIds));

        // 5. Devolver las asistencias creadas
        return creadas;
    }
}