package com.example.martinez.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.hibernate.annotations.UuidGenerator;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "pago_mensual", uniqueConstraints = {
        @UniqueConstraint(name = "uk_pago_mes", columnNames = {"contrato_arriendo_id", "mes", "anio"})
})
public class PagoMensualModel {
    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "id", columnDefinition = "uuid")
    private UUID id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "contrato_arriendo_id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private ContratoArriendoModel contratoArriendo;

    @Column(name = "mes", nullable = false)
    private Integer mes;

    @Column(name = "anio", nullable = false)
    private Integer anio;

    @Column(name = "valor_arriendo", nullable = false, precision = 12, scale = 2)
    private BigDecimal valorArriendo;

    @Column(name = "valor_administracion", nullable = false, precision = 12, scale = 2)
    private BigDecimal valorAdministracion;

    @Column(name = "total_neto", nullable = false, precision = 12, scale = 2)
    private BigDecimal totalNeto;

    @Column(name = "fecha_pago")
    private LocalDate fechaPago;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public ContratoArriendoModel getContratoArriendo() {
        return contratoArriendo;
    }

    public void setContratoArriendo(ContratoArriendoModel contratoArriendo) {
        this.contratoArriendo = contratoArriendo;
    }

    public Integer getMes() {
        return mes;
    }

    public void setMes(Integer mes) {
        this.mes = mes;
    }

    public Integer getAnio() {
        return anio;
    }

    public void setAnio(Integer anio) {
        this.anio = anio;
    }

    public BigDecimal getValorArriendo() {
        return valorArriendo;
    }

    public void setValorArriendo(BigDecimal valorArriendo) {
        this.valorArriendo = valorArriendo;
    }

    public BigDecimal getValorAdministracion() {
        return valorAdministracion;
    }

    public void setValorAdministracion(BigDecimal valorAdministracion) {
        this.valorAdministracion = valorAdministracion;
    }

    public BigDecimal getTotalNeto() {
        return totalNeto;
    }

    public void setTotalNeto(BigDecimal totalNeto) {
        this.totalNeto = totalNeto;
    }

    public LocalDate getFechaPago() {
        return fechaPago;
    }

    public void setFechaPago(LocalDate fechaPago) {
        this.fechaPago = fechaPago;
    }
}
