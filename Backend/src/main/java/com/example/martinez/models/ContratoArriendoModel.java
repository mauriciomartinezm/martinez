package com.example.martinez.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.hibernate.annotations.UuidGenerator;

import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "contrato_arriendo")
public class ContratoArriendoModel {
    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "id", columnDefinition = "uuid")
    private UUID id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "apartamento_id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private ApartamentoModel apartamento;

    @ManyToOne(optional = false)
    @JoinColumn(name = "arrendatario_id", nullable = false)
    private ArrendatarioModel arrendatario;

    @Column(name = "fecha_inicio", nullable = false)
    private LocalDate fechaInicio;

    @Column(name = "fecha_fin")
    private LocalDate fechaFin;

    @Column(name = "activo")
    private Boolean activo = Boolean.TRUE;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public ApartamentoModel getApartamento() {
        return apartamento;
    }

    public void setApartamento(ApartamentoModel apartamento) {
        this.apartamento = apartamento;
    }

    public ArrendatarioModel getArrendatario() {
        return arrendatario;
    }

    public void setArrendatario(ArrendatarioModel arrendatario) {
        this.arrendatario = arrendatario;
    }

    public LocalDate getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(LocalDate fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public LocalDate getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(LocalDate fechaFin) {
        this.fechaFin = fechaFin;
    }

    public Boolean getActivo() {
        return activo;
    }

    public void setActivo(Boolean activo) {
        this.activo = activo;
    }
}
