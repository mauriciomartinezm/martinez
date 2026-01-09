package com.example.martinez.service;

import com.example.martinez.models.ContratoArriendoModel;
import com.example.martinez.repository.ContratoArriendoModelRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class ContratoArriendoService {

    private final ContratoArriendoModelRepository contratoRepository;

    public ContratoArriendoService(ContratoArriendoModelRepository contratoRepository) {
        this.contratoRepository = contratoRepository;
    }

    // Crear o actualizar contrato
    public ContratoArriendoModel guardar(ContratoArriendoModel contrato) {
        return contratoRepository.save(contrato);
    }

    // Obtener todos los contratos
    @Transactional(readOnly = true)
    public List<ContratoArriendoModel> obtenerTodos() {
        return contratoRepository.findAll();
    }

    // Obtener contrato por ID
    @Transactional(readOnly = true)
    public Optional<ContratoArriendoModel> obtenerPorId(UUID id) {
        return contratoRepository.findById(id);
    }

    // Obtener contratos por apartamento ID
    @Transactional(readOnly = true)
    public List<ContratoArriendoModel> obtenerPorApartamentoId(UUID apartamentoId) {
        return contratoRepository.findByApartamentoId(apartamentoId);
    }

    // Obtener contratos por arrendatario ID
    @Transactional(readOnly = true)
    public List<ContratoArriendoModel> obtenerPorArrendatarioId(UUID arrendatarioId) {
        return contratoRepository.findByArrendatarioId(arrendatarioId);
    }

    // Obtener contratos activos
    @Transactional(readOnly = true)
    public List<ContratoArriendoModel> obtenerActivos() {
        return contratoRepository.findByActivoTrue();
    }

    // Obtener contratos activos de un apartamento
    @Transactional(readOnly = true)
    public List<ContratoArriendoModel> obtenerActivosPorApartamentoId(UUID apartamentoId) {
        return contratoRepository.findByApartamentoIdAndActivoTrue(apartamentoId);
    }

    // Obtener contratos activos de un arrendatario
    @Transactional(readOnly = true)
    public List<ContratoArriendoModel> obtenerActivosPorArrendatarioId(UUID arrendatarioId) {
        return contratoRepository.findByArrendatarioIdAndActivoTrue(arrendatarioId);
    }

    // Activar contrato
    public ContratoArriendoModel activar(UUID id) {
        Optional<ContratoArriendoModel> contratoOpt = contratoRepository.findById(id);
        if (contratoOpt.isPresent()) {
            ContratoArriendoModel contrato = contratoOpt.get();
            contrato.setActivo(true);
            return contratoRepository.save(contrato);
        }
        return null;
    }

    // Desactivar contrato
    public ContratoArriendoModel desactivar(UUID id) {
        Optional<ContratoArriendoModel> contratoOpt = contratoRepository.findById(id);
        if (contratoOpt.isPresent()) {
            ContratoArriendoModel contrato = contratoOpt.get();
            contrato.setActivo(false);
            return contratoRepository.save(contrato);
        }
        return null;
    }

    // Eliminar contrato por ID
    public void eliminarPorId(UUID id) {
        contratoRepository.deleteById(id);
    }

    // Contar total de contratos
    @Transactional(readOnly = true)
    public long contar() {
        return contratoRepository.count();
    }
}
