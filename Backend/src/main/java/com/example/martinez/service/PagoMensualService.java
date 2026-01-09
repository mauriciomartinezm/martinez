package com.example.martinez.service;

import com.example.martinez.models.PagoMensualModel;
import com.example.martinez.repository.PagoMensualModelRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class PagoMensualService {

    private final PagoMensualModelRepository pagoRepository;

    public PagoMensualService(PagoMensualModelRepository pagoRepository) {
        this.pagoRepository = pagoRepository;
    }

    // Crear o actualizar pago mensual
    public PagoMensualModel guardar(PagoMensualModel pago) {
        return pagoRepository.save(pago);
    }

    // Obtener todos los pagos
    @Transactional(readOnly = true)
    public List<PagoMensualModel> obtenerTodos() {
        return pagoRepository.findAll();
    }

    // Obtener pago por ID
    @Transactional(readOnly = true)
    public Optional<PagoMensualModel> obtenerPorId(UUID id) {
        return pagoRepository.findById(id);
    }

    // Obtener pagos por contrato ID
    @Transactional(readOnly = true)
    public List<PagoMensualModel> obtenerPorContratoId(UUID contratoId) {
        return pagoRepository.findByContratoArriendoId(contratoId);
    }

    // Obtener pagos por contrato ID y año
    @Transactional(readOnly = true)
    public List<PagoMensualModel> obtenerPorContratoIdYAnio(UUID contratoId, Integer anio) {
        return pagoRepository.findByContratoArriendoIdAndAnio(contratoId, anio);
    }

    // Obtener pago específico por contrato, mes y año
    @Transactional(readOnly = true)
    public Optional<PagoMensualModel> obtenerPorContratoMesAnio(UUID contratoId, Integer mes, Integer anio) {
        return pagoRepository.findByContratoArriendoIdAndMesAndAnio(contratoId, mes, anio);
    }

    // Obtener pagos pendientes (sin fecha de pago)
    @Transactional(readOnly = true)
    public List<PagoMensualModel> obtenerPendientes() {
        return pagoRepository.findByFechaPagoIsNull();
    }

    // Obtener pagos realizados (con fecha de pago)
    @Transactional(readOnly = true)
    public List<PagoMensualModel> obtenerRealizados() {
        return pagoRepository.findByFechaPagoIsNotNull();
    }

    // Obtener pagos pendientes de un contrato
    @Transactional(readOnly = true)
    public List<PagoMensualModel> obtenerPendientesPorContratoId(UUID contratoId) {
        return pagoRepository.findByContratoArriendoIdAndFechaPagoIsNull(contratoId);
    }

    // Marcar pago como realizado
    public PagoMensualModel marcarComoPagado(UUID id, LocalDate fechaPago) {
        Optional<PagoMensualModel> pagoOpt = pagoRepository.findById(id);
        if (pagoOpt.isPresent()) {
            PagoMensualModel pago = pagoOpt.get();
            pago.setFechaPago(fechaPago);
            return pagoRepository.save(pago);
        }
        return null;
    }

    // Eliminar pago por ID
    public void eliminarPorId(UUID id) {
        pagoRepository.deleteById(id);
    }

    // Contar total de pagos
    @Transactional(readOnly = true)
    public long contar() {
        return pagoRepository.count();
    }
}
