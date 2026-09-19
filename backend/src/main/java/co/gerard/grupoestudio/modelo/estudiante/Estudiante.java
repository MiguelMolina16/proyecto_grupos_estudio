package co.gerard.grupoestudio.modelo.estudiante;

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
@Table(name = "estudiantes")
public class Estudiante extends PanacheEntityBase {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "est_id")
    public UUID estId;

    @Column(name = "est_nombres", nullable = false, length = 50)
    public String estNombres;

    @Column(name = "est_apellidos", nullable = false, length = 50)
    public String estApellidos;

    @Column(name = "est_email", length = 100)
    public String estEmail;

    @Column(name = "est_creacion")
    public LocalDateTime estCreacion;

    // Método estático tipado para no tener que castear en el Resource
    public static Estudiante findById(UUID id) {
        return find("estId", id).firstResult();
    }
}