package co.gerard.grupoestudio.rest;

import co.gerard.grupoestudio.modelo.grupo.Grupo;
import co.gerard.grupoestudio.modelo.reunion.Reunion;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.sql.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Path("/reuniones")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class ReunionResource {

    @GET
    public List<Reunion> listar() {
        return Reunion.listAll();
    }

    // HU020: consultar reuniones de un grupo por una fecha o rango de fechas.
    // Formato esperado para las fechas: AAAA-MM-DD.
    @GET
    @Path("/buscar")
    public Response buscarPorFecha(
            @QueryParam("gruId") String gruIdTexto,
            @QueryParam("fechaInicio") String fechaInicioTexto,
            @QueryParam("fechaFin") String fechaFinTexto) {

        if (gruIdTexto == null || gruIdTexto.isBlank()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("mensaje", "Debe seleccionar un grupo de estudio."))
                    .build();
        }
        if (fechaInicioTexto == null || fechaInicioTexto.isBlank()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("mensaje", "Debe ingresar la fecha inicial."))
                    .build();
        }

        final UUID gruId;
        final LocalDate fechaInicio;
        final LocalDate fechaFin;
        try {
            gruId = UUID.fromString(gruIdTexto);
            fechaInicio = LocalDate.parse(fechaInicioTexto);
            fechaFin = (fechaFinTexto == null || fechaFinTexto.isBlank())
                    ? fechaInicio
                    : LocalDate.parse(fechaFinTexto);
        } catch (IllegalArgumentException | DateTimeParseException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("mensaje", "El grupo o las fechas tienen un formato inválido. Use AAAA-MM-DD."))
                    .build();
        }

        if (fechaInicio.isAfter(fechaFin)) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("mensaje", "La fecha inicial no puede ser posterior a la fecha final."))
                    .build();
        }

        if (Grupo.findById(gruId) == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(Map.of("mensaje", "El grupo seleccionado no existe."))
                    .build();
        }

        List<Reunion> reuniones = Reunion.list(
                "gruId = ?1 and reuFecha >= ?2 and reuFecha <= ?3 order by reuFecha, reuHora",
                gruId, Date.valueOf(fechaInicio), Date.valueOf(fechaFin));

        return Response.ok(reuniones).build();
    }

    @GET
    @Path("/{id}")
    public Response getPorId(@PathParam("id") UUID id) {
        Reunion reunion = Reunion.findById(id);
        if (reunion == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(Map.of("mensaje", "No se encontró la reunión solicitada."))
                    .build();
        }
        return Response.ok(reunion).build();
    }

    @POST
    @Transactional
    public Response crear(Reunion reunion) {
        if (reunion == null) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("mensaje", "Debe enviar la información de la reunión."))
                    .build();
        }

        if (reunion.gruId == null) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("mensaje", "Debe seleccionar un grupo de estudio."))
                    .build();
        }

        if (reunion.reuFecha == null) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("mensaje", "La fecha de la reunión es obligatoria."))
                    .build();
        }

        Grupo grupo = Grupo.findById(reunion.gruId);
        if (grupo == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(Map.of("mensaje", "El grupo seleccionado no existe."))
                    .build();
        }

        if (reunion.reuLocalizacion == null || reunion.reuLocalizacion.isBlank()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("mensaje", "Debe indicar el lugar o modalidad de la reunión."))
                    .build();
        }

        if (reunion.reuDescripcion == null || reunion.reuDescripcion.isBlank()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("mensaje", "La descripción de la reunión es obligatoria."))
                    .build();
        }

        reunion.reuLocalizacion = reunion.reuLocalizacion.trim();
        reunion.reuDescripcion = reunion.reuDescripcion.trim();
        if (reunion.reuCreacion == null) {
            reunion.reuCreacion = LocalDateTime.now();
        }

        reunion.persist();
        return Response.status(Response.Status.CREATED).entity(reunion).build();
    }
}
