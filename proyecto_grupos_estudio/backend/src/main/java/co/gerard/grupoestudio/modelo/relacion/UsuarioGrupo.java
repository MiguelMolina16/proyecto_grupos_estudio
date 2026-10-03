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
@Table(name = "usuarios_grupos")
@IdClass(UsuarioGrupoId.class)
public class UsuarioGrupo extends PanacheEntityBase {

    @Id
    @Column(name = "usu_id")
    public UUID usuId;

    @Id
    @Column(name = "gru_id")
    public UUID gruId;

    @Column(name = "rol", length = 50)
    public String rol;

    public static UsuarioGrupo buscarPorId(UUID usuId, UUID gruId) {
        return find("usuId = ?1 and gruId = ?2", usuId, gruId).firstResult();
    }

    public static List<UsuarioGrupo> buscarPorGrupo(UUID gruId) {
        return list("gruId", gruId);
    }

    public static List<UsuarioGrupo> buscarPorUsuario(UUID usuId) {
        return list("usuId", usuId);
    }
}