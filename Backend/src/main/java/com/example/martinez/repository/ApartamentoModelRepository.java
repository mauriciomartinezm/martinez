package com.example.martinez.repository;

import com.example.martinez.models.ApartamentoModel;
import com.example.martinez.models.EdificioModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ApartamentoModelRepository extends JpaRepository<ApartamentoModel, UUID> {
    // Buscar apartamentos por edificio
    List<ApartamentoModel> findByEdificio(EdificioModel edificio);
    
    // Buscar apartamentos por edificio ID
    List<ApartamentoModel> findByEdificioId(UUID edificioId);
    
    // Buscar apartamentos activos
    List<ApartamentoModel> findByActivaTrue();
    
    // Buscar apartamentos activos de un edificio
    List<ApartamentoModel> findByEdificioIdAndActivaTrue(UUID edificioId);
}
