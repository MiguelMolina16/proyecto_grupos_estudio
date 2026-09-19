package co.gerard.grupoestudio.modelo.relacion;

import java.io.Serializable;
import java.util.Objects;
import java.util.UUID;

public class EstudianteGrupoId implements Serializable {

    public UUID estId;
    public UUID gruId;

    public EstudianteGrupoId() {}

    public EstudianteGrupoId(UUID estId, UUID gruId) {
        this.estId = estId;
        this.gruId = gruId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof EstudianteGrupoId)) return false;
        EstudianteGrupoId that = (EstudianteGrupoId) o;
        return Objects.equals(estId, that.estId) && Objects.equals(gruId, that.gruId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(estId, gruId);
    }
}