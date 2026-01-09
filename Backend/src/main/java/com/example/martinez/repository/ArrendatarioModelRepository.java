package com.example.martinez.repository;

import com.example.martinez.models.ArrendatarioModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface ArrendatarioModelRepository extends JpaRepository<ArrendatarioModel, UUID> {
    // Buscar arrendatario por correo
    Optional<ArrendatarioModel> findByCorreo(String correo);
    
    // Buscar arrendatarios por nombre (contiene texto)
    List<ArrendatarioModel> findByNombreContainingIgnoreCase(String nombre);
    
    // Buscar arrendatario por teléfono
    Optional<ArrendatarioModel> findByTelefono(String telefono);
}
