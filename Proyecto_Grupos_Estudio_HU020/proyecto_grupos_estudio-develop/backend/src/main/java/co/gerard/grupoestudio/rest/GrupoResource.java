package co.gerard.grupoestudio.rest;

import co.gerard.grupoestudio.modelo.grupo.Grupo;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import java.util.List;
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
        return Grupo.findById(id);
    }

    @POST
    @Transactional 
    public Grupo crear(Grupo grupo) {
        grupo.persist();
        return grupo;
    }
}
