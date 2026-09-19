package co.gerard.grupoestudio.modelo.asistencia;

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
@Table(name = "asistencias")
public class Asistencia extends PanacheEntityBase {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "asi_id")
    public UUID asiId;

    @Column(name = "reu_id", nullable = false)
    public UUID reuId;

    @Column(name = "est_id", nullable = false)
    public UUID estId;

    @Column(name = "asi_creacion")
    public LocalDateTime asiCreacion;

    // CLAVE ÚNICA para evitar duplicados (meeting_id, student_id)
    // En PostgreSQL se maneja con CONSTRAINT UNIQUE explícito en el SQL

    // Método estático tipado
    public static Asistencia findById(UUID id) {
        return find("asiId", id).firstResult();
    }
}
