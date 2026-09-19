package co.gerard.grupoestudio.evento;

import java.util.List;
import java.util.UUID;

public class AsistenciaRegistradaEvent {
    public final UUID reuId;
    public final List<UUID> estIds;

    public AsistenciaRegistradaEvent(UUID reuId, List<UUID> estIds) {
        this.reuId = reuId;
        this.estIds = estIds;
    }
}