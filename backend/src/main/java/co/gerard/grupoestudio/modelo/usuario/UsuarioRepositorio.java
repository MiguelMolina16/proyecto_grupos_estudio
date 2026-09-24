package co.gerard.grupoestudio.modelo.usuario;

import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class UsuarioRepositorio implements PanacheRepository<Usuario> {
}