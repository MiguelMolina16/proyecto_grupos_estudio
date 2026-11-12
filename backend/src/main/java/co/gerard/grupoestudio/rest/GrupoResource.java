package co.gerard.grupoestudio.rest;

import co.gerard.grupoestudio.modelo.grupo.Grupo;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.NotFoundException;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Path("/grupos")
public class GrupoResource {

    @GET
    public List<Grupo> listar() {
        return Grupo.listAll();
    }

    @GET
    @Path("/{id}")
    public Grupo getPorId(@PathParam("id") UUID id) {
        Grupo grupo = Grupo.findById(id);
        if (grupo == null) throw new NotFoundException("Grupo no encontrado");
        return grupo;
    }

    @POST
    @Transactional
    public Response crear(Grupo grupo) {

        // Validar nombre
        if (grupo.gruNombre == null || grupo.gruNombre.trim().isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("error", "El nombre del grupo es obligatorio"))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        }

        // Validar descripción
        if (grupo.gruDescripcion == null || grupo.gruDescripcion.trim().isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("error", "La descripción del grupo es obligatoria"))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        }

        // Asignar fecha de creación automática
        grupo.gruCreacion = LocalDateTime.now();

        grupo.persist();

        return Response.status(Response.Status.CREATED)
                .entity(grupo)
                .build();
    }
}