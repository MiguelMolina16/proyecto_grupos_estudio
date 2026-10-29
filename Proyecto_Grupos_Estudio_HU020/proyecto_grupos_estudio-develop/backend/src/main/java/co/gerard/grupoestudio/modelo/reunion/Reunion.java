package co.gerard.grupoestudio.modelo.reunion;

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
@Table(name = "reuniones")
public class Reunion extends PanacheEntityBase {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "reu_id")
    public UUID reuId;

    @Column(name = "gru_id", nullable = false)
    public UUID gruId;

    @Column(name = "reu_fecha", nullable = false)
    public java.sql.Date reuFecha;

    @Column(name = "reu_hora")
    public java.time.LocalTime reuHora;

    @Column(name = "reu_localizacion", length = 100)
    public String reuLocalizacion;

    @Column(name = "reu_descripcion")
    public String reuDescripcion;

    @Column(name = "reu_creacion")
    public LocalDateTime reuCreacion;

    // Método estático tipado
    public static Reunion findById(UUID id) {
        return find("reuId", id).firstResult();
    }
}
