package co.gerard.grupoestudio.modelo.tarea;

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
@Table(name = "tareas")
public class Tarea extends PanacheEntityBase {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "tar_id")
    public UUID tarId;

    @Column(name = "reu_id", nullable = false)
    public UUID reuId;

    @Column(name = "usu_id", nullable = false)
    public UUID usuId;

    @Column(name = "tar_descripcion", nullable = false)
    public String tarDescripcion;

    @Column(name = "tar_completada", nullable = false)
    public Boolean tarCompletada = false;

    @Column(name = "tar_creacion")
    public LocalDateTime tarCreacion;

    public static Tarea findById(UUID id) {
        return find("tarId", id).firstResult();
    }
}