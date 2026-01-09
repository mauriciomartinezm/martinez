package com.example.martinez.repository;

import com.example.martinez.models.EdificioModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface EdificioModelRepository extends JpaRepository<EdificioModel, UUID> {
    // Buscar edificios por nombre (contiene texto)
    List<EdificioModel> findByNombreContainingIgnoreCase(String nombre);
    
    // Buscar edificios por dirección
    List<EdificioModel> findByDireccionContainingIgnoreCase(String direccion);
}
