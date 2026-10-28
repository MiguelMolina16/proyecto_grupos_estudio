package co.gerard.grupoestudio.modelo.usuario;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "credenciales")
public class Credencial extends PanacheEntityBase {

    @Id
    @Column(name = "usu_id")
    public UUID usuId;

    @Column(name = "cre_password_hash", nullable = false)
    public String crePasswordHash;

    @Column(name = "cre_creacion")
    public LocalDateTime creCreacion;

    @Column(name = "cre_actualizacion")
    public LocalDateTime creActualizacion;

    @Column(name = "cre_intentos_fallidos")
    public Integer creIntentosFallidos;
}