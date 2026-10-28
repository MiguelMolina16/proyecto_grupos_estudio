package co.gerard.grupoestudio.servicio;

import co.gerard.grupoestudio.dto.RegistroUsuarioDTO;
import co.gerard.grupoestudio.modelo.usuario.Credencial;
import co.gerard.grupoestudio.modelo.usuario.CredencialRepositorio;
import co.gerard.grupoestudio.modelo.usuario.Usuario;
import co.gerard.grupoestudio.modelo.usuario.UsuarioRepositorio;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import org.mindrot.jbcrypt.BCrypt;

import java.time.LocalDateTime;

@ApplicationScoped
public class UsuarioServicio {

    @Inject
    UsuarioRepositorio usuarioRepositorio;

    @Inject
    CredencialRepositorio credencialRepositorio;

    @Transactional
    public Usuario registrar(RegistroUsuarioDTO datos) {

        if (usuarioRepositorio.find("usuEmail", datos.email).firstResult() != null) {
            throw new IllegalArgumentException("El correo ya está registrado");
        }

        if (!"Estudiante".equals(datos.rol) && !"Profesor".equals(datos.rol)) {
            throw new IllegalArgumentException(
                    "El rol debe ser Estudiante o Profesor"
            );
        }

        Usuario usuario = new Usuario();
        usuario.usuNombres = datos.nombres;
        usuario.usuApellidos = datos.apellidos;
        usuario.usuEmail = datos.email;
        usuario.usuRol = datos.rol;
        usuario.usuCreacion = LocalDateTime.now();

        usuarioRepositorio.persist(usuario);

        Credencial credencial = new Credencial();
        credencial.usuId = usuario.usuId;
        credencial.crePasswordHash = BCrypt.hashpw(
                datos.password,
                BCrypt.gensalt()
        );
        credencial.creCreacion = LocalDateTime.now();
        credencial.creIntentosFallidos = 0;

        credencialRepositorio.persist(credencial);

        return usuario;
    }

    public Usuario autenticar(String email, String password) {

        Usuario usuario = usuarioRepositorio
                .find("usuEmail", email)
                .firstResult();

        if (usuario == null) {
            return null;
        }

        Credencial credencial = credencialRepositorio
                .find("usuId", usuario.usuId)
                .firstResult();

        if (credencial == null) {
            return null;
        }

        if (!BCrypt.checkpw(password, credencial.crePasswordHash)) {
            return null;
        }

        return usuario;
    }
}