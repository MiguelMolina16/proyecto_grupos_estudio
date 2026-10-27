package co.gerard.grupoestudio.evento;

import java.util.List;
import java.util.UUID;

public class AsistenciaRegistradaEvent {
    public UUID reuId;
    public List<UUID> usuIds;

    public AsistenciaRegistradaEvent(UUID reuId, List<UUID> usuIds) {
        this.reuId = reuId;
        this.usuIds = usuIds;
    }
}