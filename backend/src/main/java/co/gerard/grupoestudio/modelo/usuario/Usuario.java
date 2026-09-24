package co.gerard.grupoestudio.modelo.usuario;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "usuarios")
public class Usuario extends PanacheEntityBase {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "usu_id")
    public UUID usuId;

    @NotBlank
    @Column(name = "usu_nombres", nullable = false)
    public String usuNombres;

    @NotBlank
    @Column(name = "usu_apellidos", nullable = false)
    public String usuApellidos;

    @NotBlank
    @Email
    @Column(name = "usu_email")
    public String usuEmail;

    @Column(name = "usu_creacion")
    public LocalDateTime usuCreacion;

    @NotBlank
    @Column(name = "usu_rol", nullable = false)
    public String usuRol;

    public static Usuario findById(UUID id) {
        return find("usuId", id).firstResult();
    }
}