package co.gerard.grupoestudio.rest;

import co.gerard.grupoestudio.modelo.reunion.Reunion;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import java.util.List;
import java.util.UUID;

@Path("/reuniones")
public class ReunionResource {

    @GET
    public List<Reunion> listar() {
        return Reunion.listAll();
    }

    @GET
    @Path("/{id}")
    public Reunion getPorId(@PathParam("id") UUID id) {
        return Reunion.findById(id);
    }

    @POST
    @Transactional
    public Reunion crear(Reunion reunion) {
        reunion.persist();
        return reunion;
    }
}
