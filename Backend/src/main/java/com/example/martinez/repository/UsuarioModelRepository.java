package com.example.martinez.repository;

import com.example.martinez.models.UsuarioModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UsuarioModelRepository extends JpaRepository<UsuarioModel, UUID> {
    // Buscar usuario por username
    Optional<UsuarioModel> findByUsername(String username);
    
    // Verificar si existe un usuario con ese username
    boolean existsByUsername(String username);
}
