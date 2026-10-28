package co.gerard.grupoestudio.rest;

import co.gerard.grupoestudio.dto.RegistroUsuarioDTO;
import co.gerard.grupoestudio.modelo.usuario.Usuario;
import co.gerard.grupoestudio.servicio.UsuarioServicio;
import io.quarkus.test.InjectMock;
import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.is;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@QuarkusTest
class UsuarioResourceTest {

    @InjectMock
    UsuarioServicio usuarioServicio;

    @Test
    void debeRegistrarUsuario() {

        RegistroUsuarioDTO datos = new RegistroUsuarioDTO();
        datos.nombres = "Juan";
        datos.apellidos = "Perez";
        datos.email = "juan@example.com";
        datos.password = "123456";
        datos.rol = "Estudiante";

        Usuario usuario = new Usuario();
        usuario.usuNombres = "Juan";
        usuario.usuApellidos = "Perez";
        usuario.usuEmail = "juan@example.com";
        usuario.usuRol = "Estudiante";

        when(usuarioServicio.registrar(any(RegistroUsuarioDTO.class)))
                .thenReturn(usuario);

        given()
                .contentType("application/json")
                .body(datos)
                .when()
                .post("/usuarios")
                .then()
                .statusCode(201)
                .body("usuNombres", is("Juan"))
                .body("usuApellidos", is("Perez"))
                .body("usuEmail", is("juan@example.com"))
                .body("usuRol", is("Estudiante"));
    }
}