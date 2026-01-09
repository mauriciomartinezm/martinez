package com.example.martinez.service;

import com.example.martinez.models.ApartamentoModel;
import com.example.martinez.repository.ApartamentoModelRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class ApartamentoService {

    private final ApartamentoModelRepository apartamentoRepository;

    public ApartamentoService(ApartamentoModelRepository apartamentoRepository) {
        this.apartamentoRepository = apartamentoRepository;
    }

    // Crear o actualizar apartamento
    public ApartamentoModel guardar(ApartamentoModel apartamento) {
        return apartamentoRepository.save(apartamento);
    }

    // Obtener todos los apartamentos
    @Transactional(readOnly = true)
    public List<ApartamentoModel> obtenerTodos() {
        return apartamentoRepository.findAll();
    }

    // Obtener apartamento por ID
    @Transactional(readOnly = true)
    public Optional<ApartamentoModel> obtenerPorId(UUID id) {
        return apartamentoRepository.findById(id);
    }

    // Obtener apartamentos por edificio ID
    @Transactional(readOnly = true)
    public List<ApartamentoModel> obtenerPorEdificioId(UUID edificioId) {
        return apartamentoRepository.findByEdificioId(edificioId);
    }

    // Obtener apartamentos activos
    @Transactional(readOnly = true)
    public List<ApartamentoModel> obtenerActivos() {
        return apartamentoRepository.findByActivaTrue();
    }

    // Obtener apartamentos activos de un edificio
    @Transactional(readOnly = true)
    public List<ApartamentoModel> obtenerActivosPorEdificioId(UUID edificioId) {
        return apartamentoRepository.findByEdificioIdAndActivaTrue(edificioId);
    }

    // Activar apartamento
    public ApartamentoModel activar(UUID id) {
        Optional<ApartamentoModel> apto = apartamentoRepository.findById(id);
        if (apto.isPresent()) {
            ApartamentoModel apartamento = apto.get();
            apartamento.setActiva(true);
            return apartamentoRepository.save(apartamento);
        }
        return null;
    }

    // Desactivar apartamento
    public ApartamentoModel desactivar(UUID id) {
        Optional<ApartamentoModel> apto = apartamentoRepository.findById(id);
        if (apto.isPresent()) {
            ApartamentoModel apartamento = apto.get();
            apartamento.setActiva(false);
            return apartamentoRepository.save(apartamento);
        }
        return null;
    }

    // Eliminar apartamento por ID
    public void eliminarPorId(UUID id) {
        apartamentoRepository.deleteById(id);
    }

    // Contar total de apartamentos
    @Transactional(readOnly = true)
    public long contar() {
        return apartamentoRepository.count();
    }
}
