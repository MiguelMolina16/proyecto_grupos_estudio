package co.gerard.grupoestudio.modelo.relacion;

import java.io.Serializable;
import java.util.Objects;
import java.util.UUID;

public class UsuarioGrupoId implements Serializable {

    public UUID usuId;
    public UUID gruId;

    public UsuarioGrupoId() {}

    public UsuarioGrupoId(UUID usuId, UUID gruId) {
        this.usuId = usuId;
        this.gruId = gruId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof UsuarioGrupoId)) return false;
        UsuarioGrupoId that = (UsuarioGrupoId) o;
        return Objects.equals(usuId, that.usuId) && Objects.equals(gruId, that.gruId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(usuId, gruId);
    }
}