package com.example.martinez.service;

import com.example.martinez.models.UsuarioModel;
import com.example.martinez.repository.UsuarioModelRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class UsuarioService {

    private final UsuarioModelRepository usuarioRepository;

    public UsuarioService(UsuarioModelRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    // Crear o actualizar usuario
    public UsuarioModel guardar(UsuarioModel usuario) {
        return usuarioRepository.save(usuario);
    }

    // Obtener todos los usuarios
    @Transactional(readOnly = true)
    public List<UsuarioModel> obtenerTodos() {
        return usuarioRepository.findAll();
    }

    // Obtener usuario por ID
    @Transactional(readOnly = true)
    public Optional<UsuarioModel> obtenerPorId(UUID id) {
        return usuarioRepository.findById(id);
    }

    // Obtener usuario por username
    @Transactional(readOnly = true)
    public Optional<UsuarioModel> obtenerPorUsername(String username) {
        return usuarioRepository.findByUsername(username);
    }

    // Verificar si existe un username
    @Transactional(readOnly = true)
    public boolean existePorUsername(String username) {
        return usuarioRepository.existsByUsername(username);
    }

    // Eliminar usuario por ID
    public void eliminarPorId(UUID id) {
        usuarioRepository.deleteById(id);
    }

    // Contar total de usuarios
    @Transactional(readOnly = true)
    public long contar() {
        return usuarioRepository.count();
    }
}
