package co.gerard.grupoestudio.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public class RegistroUsuarioDTO {

    @NotBlank
    public String nombres;

    @NotBlank
    public String apellidos;

    @NotBlank
    @Email
    public String email;

    @NotBlank
    public String password;

    @NotBlank
    public String rol;
}