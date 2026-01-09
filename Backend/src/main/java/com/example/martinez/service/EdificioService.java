package com.example.martinez.service;

import com.example.martinez.models.EdificioModel;
import com.example.martinez.repository.EdificioModelRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class EdificioService {

    private final EdificioModelRepository edificioRepository;

    public EdificioService(EdificioModelRepository edificioRepository) {
        this.edificioRepository = edificioRepository;
    }

    // Crear o actualizar edificio
    public EdificioModel guardar(EdificioModel edificio) {
        return edificioRepository.save(edificio);
    }

    // Obtener todos los edificios
    @Transactional(readOnly = true)
    public List<EdificioModel> obtenerTodos() {
        return edificioRepository.findAll();
    }

    // Obtener edificio por ID
    @Transactional(readOnly = true)
    public Optional<EdificioModel> obtenerPorId(UUID id) {
        return edificioRepository.findById(id);
    }

    // Buscar edificios por nombre
    @Transactional(readOnly = true)
    public List<EdificioModel> buscarPorNombre(String nombre) {
        return edificioRepository.findByNombreContainingIgnoreCase(nombre);
    }

    // Buscar edificios por dirección
    @Transactional(readOnly = true)
    public List<EdificioModel> buscarPorDireccion(String direccion) {
        return edificioRepository.findByDireccionContainingIgnoreCase(direccion);
    }

    // Eliminar edificio por ID
    public void eliminarPorId(UUID id) {
        edificioRepository.deleteById(id);
    }

    // Contar total de edificios
    @Transactional(readOnly = true)
    public long contar() {
        return edificioRepository.count();
    }
}
