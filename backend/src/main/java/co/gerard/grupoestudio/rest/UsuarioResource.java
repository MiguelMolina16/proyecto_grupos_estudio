
package co.gerard.grupoestudio.rest;

import co.gerard.grupoestudio.dto.RegistroUsuarioDTO;
import co.gerard.grupoestudio.modelo.usuario.Usuario;
import co.gerard.grupoestudio.servicio.UsuarioServicio;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.core.Response;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@Path("/usuarios")
public class UsuarioResource {

    @Inject
    UsuarioServicio usuarioServicio;

    // Registrar usuario
    @POST
    public Response registrar(@Valid RegistroUsuarioDTO datos) {
        try {
            Usuario usuario = usuarioServicio.registrar(datos);

            return Response
                    .status(Response.Status.CREATED)
                    .entity(usuario)
                    .build();

        } catch (IllegalArgumentException e) {
            return Response
                    .status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("message", e.getMessage()))
                    .build();
        }
    }

    // Autenticar usuario
    @POST
    @Path("/autenticar")
    public Response autenticar(Map<String, String> datos) {
        String email = datos.get("email");
        String password = datos.get("password");

        if (email == null || password == null
                || email.isBlank() || password.isBlank()) {
            return Response
                    .status(Response.Status.BAD_REQUEST)
                    .entity(Map.of(
                            "message",
                            "El correo y la contraseña son obligatorios"
                    ))
                    .build();
        }

        Usuario usuario = usuarioServicio.autenticar(email, password);

        if (usuario == null) {
            return Response
                    .status(Response.Status.UNAUTHORIZED)
                    .entity(Map.of(
                            "message",
                            "Correo o contraseña incorrectos"
                    ))
                    .build();
        }

        return Response.ok(usuario).build();
    }

    // Listar usuarios
    @GET
    public List<Usuario> listar() {
        return Usuario.listAll();
    }

    // Consultar usuario por ID
    @GET
    @Path("/{id}")
    public Usuario getPorId(@PathParam("id") UUID id) {
        return Usuario.findById(id);
    }

    // Crear usuario directamente
    @POST
    @Path("/crear")
    @Transactional
    public Usuario crear(Usuario usuario) {
        usuario.persist();
        return usuario;
    }
}
