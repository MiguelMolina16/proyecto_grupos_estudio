package co.gerard.grupoestudio.rest;

import co.gerard.grupoestudio.modelo.estudiante.Estudiante;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;

import java.util.List;
import java.util.UUID;

@Path("/estudiantes")
public class EstudianteResource {

    @GET
    public List<Estudiante> listar() {
        return Estudiante.listAll();
    }

    @GET
    @Path("/{id}")
    public Estudiante getPorId(@PathParam("id") UUID id) {
        return Estudiante.findById(id);
    }

    @POST
    @Transactional  
    public Estudiante crear(Estudiante estudiante) {
        estudiante.persist();
        return estudiante;
    }
}