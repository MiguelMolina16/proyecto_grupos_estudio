package co.gerard.grupoestudio.dto;

import java.util.UUID;

public class TareaRequest {
    public UUID reuId;
    public UUID usuId; // Si es null, el backend asume que es para todo el grupo
    public String tarDescripcion;
}