package co.gerard.grupoestudio.servicio;

import co.gerard.grupoestudio.dto.RegistroUsuarioDTO;
import co.gerard.grupoestudio.modelo.usuario.Credencial;
import co.gerard.grupoestudio.modelo.usuario.CredencialRepositorio;
import co.gerard.grupoestudio.modelo.usuario.Usuario;
import co.gerard.grupoestudio.modelo.usuario.UsuarioRepositorio;
import io.quarkus.hibernate.orm.panache.PanacheQuery;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentMatchers;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UsuarioServicioTest {

    @Mock
    UsuarioRepositorio usuarioRepositorio;

    @Mock
    CredencialRepositorio credencialRepositorio;

    @Mock
    PanacheQuery<Usuario> consulta;

    @InjectMocks
    UsuarioServicio usuarioServicio;

    @Test
    void debeRegistrarUsuarioCuandoElCorreoNoExiste() {

        RegistroUsuarioDTO datos = new RegistroUsuarioDTO();
        datos.nombres = "Juan";
        datos.apellidos = "Perez";
        datos.email = "juan@example.com";
        datos.password = "123456";
        datos.rol = "Estudiante";

        when(usuarioRepositorio.find("usuEmail", datos.email))
                .thenReturn(consulta);

        when(consulta.firstResult()).thenReturn(null);

        Usuario resultado = usuarioServicio.registrar(datos);

        assertNotNull(resultado);
        assertNotNull(resultado.usuCreacion);
        assertEquals("juan@example.com", resultado.usuEmail);
        assertEquals("Estudiante", resultado.usuRol);

        verify(usuarioRepositorio).persist(resultado);

        verify(credencialRepositorio).persist(
                ArgumentMatchers.any(Credencial.class)
        );
    }

    @Test
    void debeRechazarUsuarioCuandoElCorreoYaExiste() {

        RegistroUsuarioDTO datos = new RegistroUsuarioDTO();
        datos.nombres = "Juan";
        datos.apellidos = "Perez";
        datos.email = "juan@example.com";
        datos.password = "123456";
        datos.rol = "Estudiante";

        Usuario usuarioExistente = new Usuario();
        usuarioExistente.usuEmail = "juan@example.com";

        when(usuarioRepositorio.find("usuEmail", datos.email))
                .thenReturn(consulta);

        when(consulta.firstResult()).thenReturn(usuarioExistente);

        IllegalArgumentException excepcion = assertThrows(
                IllegalArgumentException.class,
                () -> usuarioServicio.registrar(datos)
        );

        assertEquals(
                "El correo ya está registrado",
                excepcion.getMessage()
        );
    }

    @Test
    void debeRechazarUsuarioCuandoElRolNoEsValido() {

        RegistroUsuarioDTO datos = new RegistroUsuarioDTO();
        datos.nombres = "Juan";
        datos.apellidos = "Perez";
        datos.email = "juan@example.com";
        datos.password = "123456";
        datos.rol = "Administrador";

        when(usuarioRepositorio.find("usuEmail", datos.email))
                .thenReturn(consulta);

        when(consulta.firstResult()).thenReturn(null);

        IllegalArgumentException excepcion = assertThrows(
                IllegalArgumentException.class,
                () -> usuarioServicio.registrar(datos)
        );

        assertEquals(
                "El rol debe ser Estudiante o Profesor",
                excepcion.getMessage()
        );
    }
}