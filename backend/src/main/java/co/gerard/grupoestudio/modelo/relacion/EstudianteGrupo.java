package co.gerard.grupoestudio.modelo.relacion;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "estudiantes_grupos")
@IdClass(EstudianteGrupoId.class)
public class EstudianteGrupo extends PanacheEntityBase {

    @Id
    @Column(name = "est_id")
    public UUID estId;

    @Id
    @Column(name = "gru_id")
    public UUID gruId;

    @Column(name = "rol", length = 50)
    public String rol;

    public static EstudianteGrupo buscarPorId(UUID estId, UUID gruId) {
        return find("estId = ?1 and gruId = ?2", estId, gruId).firstResult();
    }

    public static List<EstudianteGrupo> buscarPorGrupo(UUID gruId) {
        return list("gruId", gruId);
    }

    public static List<EstudianteGrupo> buscarPorEstudiante(UUID estId) {
        return list("estId", estId);
    }
}