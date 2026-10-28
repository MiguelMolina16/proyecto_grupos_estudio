package co.gerard.grupoestudio.servicio;

import co.gerard.grupoestudio.modelo.usuario.Credencial;
import co.gerard.grupoestudio.modelo.usuario.CredencialRepositorio;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

import java.time.LocalDateTime;

@ApplicationScoped
public class CredencialServicio {

    @Inject
    CredencialRepositorio credencialRepositorio;

    public Credencial guardar(Credencial credencial) {
        credencial.creCreacion = LocalDateTime.now();
        credencial.creIntentosFallidos = 0;

        credencialRepositorio.persist(credencial);

        return credencial;
    }
}