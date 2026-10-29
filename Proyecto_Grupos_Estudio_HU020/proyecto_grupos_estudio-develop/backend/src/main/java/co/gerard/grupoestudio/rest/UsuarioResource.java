package co.gerard.grupoestudio.rest;

import co.gerard.grupoestudio.modelo.usuario.Usuario;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;

import java.util.List;
import java.util.UUID;

@Path("/usuarios")
public class UsuarioResource {

    @GET
    public List<Usuario> listar() {
        return Usuario.listAll();
    }

    @GET
    @Path("/{id}")
    public Usuario getPorId(@PathParam("id") UUID id) {
        return Usuario.findById(id);
    }

    @POST
    @Transactional
    public Usuario crear(Usuario usuario) {
        usuario.persist();
        return usuario;
    }
}