package com.example.martinez.dto;

import java.util.UUID;

public class ApartamentoCrearRequest {
    private UUID edificioId;
    private String piso;
    private Boolean activa;

    public UUID getEdificioId() {
        return edificioId;
    }

    public void setEdificioId(UUID edificioId) {
        this.edificioId = edificioId;
    }

    public String getPiso() {
        return piso;
    }

    public void setPiso(String piso) {
        this.piso = piso;
    }

    public Boolean getActiva() {
        return activa;
    }

    public void setActiva(Boolean activa) {
        this.activa = activa;
    }
}
