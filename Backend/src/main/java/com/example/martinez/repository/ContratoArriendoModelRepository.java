package com.example.martinez.repository;

import com.example.martinez.models.ApartamentoModel;
import com.example.martinez.models.ArrendatarioModel;
import com.example.martinez.models.ContratoArriendoModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ContratoArriendoModelRepository extends JpaRepository<ContratoArriendoModel, UUID> {
    // Buscar contratos por apartamento
    List<ContratoArriendoModel> findByApartamento(ApartamentoModel apartamento);
    
    // Buscar contratos por apartamento ID
    List<ContratoArriendoModel> findByApartamentoId(UUID apartamentoId);
    
    // Buscar contratos por arrendatario
    List<ContratoArriendoModel> findByArrendatario(ArrendatarioModel arrendatario);
    
    // Buscar contratos por arrendatario ID
    List<ContratoArriendoModel> findByArrendatarioId(UUID arrendatarioId);
    
    // Buscar contratos activos
    List<ContratoArriendoModel> findByActivoTrue();
    
    // Buscar contratos activos de un apartamento
    List<ContratoArriendoModel> findByApartamentoIdAndActivoTrue(UUID apartamentoId);
    
    // Buscar contratos activos de un arrendatario
    List<ContratoArriendoModel> findByArrendatarioIdAndActivoTrue(UUID arrendatarioId);
}
