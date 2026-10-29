package co.gerard.grupoestudio.modelo.grupo;

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
@Table(name = "grupos")
public class Grupo extends PanacheEntityBase {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "gru_id")
    public UUID gruId;

    @Column(name = "gru_nombre", nullable = false, length = 100)
    public String gruNombre;

    @Column(name = "gru_descripcion")
    public String gruDescripcion;

    @Column(name = "gru_creacion")
    public LocalDateTime gruCreacion;

    // Método estático tipado para no tener que castear en el Resource
    public static Grupo findById(UUID id) {
        return find("gruId", id).firstResult(); 
    }
}
