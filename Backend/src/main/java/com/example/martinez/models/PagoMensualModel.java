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
        @UniqueConstraint(name = "uk_pago_mes", columnNames = {"contrato_arriendo_id", "mes", "anio", "tipo"})
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

    @Column(name = "tipo", nullable = false)
    private String tipo;

    @Column(name = "mes", nullable = false)
    private String mes;

    @Column(name = "anio", nullable = false)
    private String anio;

    @Column(name = "valor_arriendo", nullable = false, precision = 12, scale = 2)
    private BigDecimal valorArriendo;

    @Column(name = "cuota_administracion", nullable = false, precision = 12, scale = 2)
    private BigDecimal cuotaAdministracion;

    @Column(name = "fondo_inmueble", precision = 12, scale = 2)
    private BigDecimal fondoInmueble;

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

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getMes() {
        return mes;
    }

    public void setMes(String mes) {
        this.mes = mes;
    }

    public String getAnio() {
        return anio;
    }

    public void setAnio(String anio) {
        this.anio = anio;
    }

    public BigDecimal getValorArriendo() {
        return valorArriendo;
    }

    public void setValorArriendo(BigDecimal valorArriendo) {
        this.valorArriendo = valorArriendo;
    }

    public BigDecimal getCuotaAdministracion() {
        return cuotaAdministracion;
    }

    public void setCuotaAdministracion(BigDecimal cuotaAdministracion) {
        this.cuotaAdministracion = cuotaAdministracion;
    }

    public BigDecimal getFondoInmueble() {
        return fondoInmueble;
    }

    public void setFondoInmueble(BigDecimal fondoInmueble) {
        this.fondoInmueble = fondoInmueble;
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
