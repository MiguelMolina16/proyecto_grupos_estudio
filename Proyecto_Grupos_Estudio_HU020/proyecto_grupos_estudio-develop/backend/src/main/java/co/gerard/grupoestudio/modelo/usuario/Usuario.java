package co.gerard.grupoestudio.modelo.usuario;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "usuarios")
public class Usuario extends PanacheEntityBase {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "usu_id")
    public UUID usuId;

    @Column(name = "usu_nombres", nullable = false, length = 50)
    public String usuNombres;

    @Column(name = "usu_apellidos", nullable = false, length = 50)
    public String usuApellidos;

    @Column(name = "usu_email", length = 100)
    public String usuEmail;

    @Column(name = "usu_creacion")
    public LocalDateTime usuCreacion;

    @Column(name = "usu_rol", nullable = false, length = 50)
    public String usuRol;

    public static Usuario findById(UUID id) {
        return find("usuId", id).firstResult();
    }
}