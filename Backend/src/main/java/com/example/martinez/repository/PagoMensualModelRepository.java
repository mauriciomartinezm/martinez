package com.example.martinez.repository;

import com.example.martinez.models.ContratoArriendoModel;
import com.example.martinez.models.PagoMensualModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface PagoMensualModelRepository extends JpaRepository<PagoMensualModel, UUID> {
    // Buscar pagos por contrato
    List<PagoMensualModel> findByContratoArriendo(ContratoArriendoModel contrato);
    
    // Buscar pagos por contrato ID
    List<PagoMensualModel> findByContratoArriendoId(UUID contratoId);
    
    // Buscar pagos por contrato y año
    List<PagoMensualModel> findByContratoArriendoIdAndAnio(UUID contratoId, Integer anio);
    
    // Buscar pago específico por contrato, mes y año
    Optional<PagoMensualModel> findByContratoArriendoIdAndMesAndAnio(UUID contratoId, Integer mes, Integer anio);
    
    // Buscar pagos pendientes (sin fecha de pago)
    List<PagoMensualModel> findByFechaPagoIsNull();
    
    // Buscar pagos realizados (con fecha de pago)
    List<PagoMensualModel> findByFechaPagoIsNotNull();
    
    // Buscar pagos pendientes de un contrato
    List<PagoMensualModel> findByContratoArriendoIdAndFechaPagoIsNull(UUID contratoId);
}
