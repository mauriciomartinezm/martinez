package com.example.martinez.service;

import com.example.martinez.models.ArrendatarioModel;
import com.example.martinez.repository.ArrendatarioModelRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class ArrendatarioService {

    private final ArrendatarioModelRepository arrendatarioRepository;

    public ArrendatarioService(ArrendatarioModelRepository arrendatarioRepository) {
        this.arrendatarioRepository = arrendatarioRepository;
    }

    // Crear o actualizar arrendatario
    public ArrendatarioModel guardar(ArrendatarioModel arrendatario) {
        return arrendatarioRepository.save(arrendatario);
    }

    // Obtener todos los arrendatarios
    @Transactional(readOnly = true)
    public List<ArrendatarioModel> obtenerTodos() {
        return arrendatarioRepository.findAll();
    }

    // Obtener arrendatario por ID
    @Transactional(readOnly = true)
    public Optional<ArrendatarioModel> obtenerPorId(UUID id) {
        return arrendatarioRepository.findById(id);
    }

    // Obtener arrendatario por correo
    @Transactional(readOnly = true)
    public Optional<ArrendatarioModel> obtenerPorCorreo(String correo) {
        return arrendatarioRepository.findByCorreo(correo);
    }

    // Obtener arrendatario por teléfono
    @Transactional(readOnly = true)
    public Optional<ArrendatarioModel> obtenerPorTelefono(String telefono) {
        return arrendatarioRepository.findByTelefono(telefono);
    }

    // Buscar arrendatarios por nombre
    @Transactional(readOnly = true)
    public List<ArrendatarioModel> buscarPorNombre(String nombre) {
        return arrendatarioRepository.findByNombreContainingIgnoreCase(nombre);
    }

    // Eliminar arrendatario por ID
    public void eliminarPorId(UUID id) {
        arrendatarioRepository.deleteById(id);
    }

    // Contar total de arrendatarios
    @Transactional(readOnly = true)
    public long contar() {
        return arrendatarioRepository.count();
    }
}
