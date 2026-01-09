package com.example.martinez.controller;

import com.example.martinez.models.ContratoArriendoModel;
import com.example.martinez.service.ContratoArriendoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/contratos")
@CrossOrigin(origins = "*", maxAge = 3600)
public class ContratoArriendoController {

    private final ContratoArriendoService contratoService;

    public ContratoArriendoController(ContratoArriendoService contratoService) {
        this.contratoService = contratoService;
    }

    @PostMapping
    public ResponseEntity<ContratoArriendoModel> crear(@RequestBody ContratoArriendoModel contrato) {
        ContratoArriendoModel contratoGuardado = contratoService.guardar(contrato);
        return ResponseEntity.status(HttpStatus.CREATED).body(contratoGuardado);
    }

    @GetMapping
    public ResponseEntity<List<ContratoArriendoModel>> obtenerTodos() {
        List<ContratoArriendoModel> contratos = contratoService.obtenerTodos();
        return ResponseEntity.ok(contratos);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ContratoArriendoModel> obtenerPorId(@PathVariable UUID id) {
        Optional<ContratoArriendoModel> contrato = contratoService.obtenerPorId(id);
        return contrato.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/apartamento/{apartamentoId}")
    public ResponseEntity<List<ContratoArriendoModel>> obtenerPorApartamentoId(@PathVariable UUID apartamentoId) {
        List<ContratoArriendoModel> contratos = contratoService.obtenerPorApartamentoId(apartamentoId);
        return ResponseEntity.ok(contratos);
    }

    @GetMapping("/arrendatario/{arrendatarioId}")
    public ResponseEntity<List<ContratoArriendoModel>> obtenerPorArrendatarioId(@PathVariable UUID arrendatarioId) {
        List<ContratoArriendoModel> contratos = contratoService.obtenerPorArrendatarioId(arrendatarioId);
        return ResponseEntity.ok(contratos);
    }

    @GetMapping("/activos")
    public ResponseEntity<List<ContratoArriendoModel>> obtenerActivos() {
        List<ContratoArriendoModel> contratos = contratoService.obtenerActivos();
        return ResponseEntity.ok(contratos);
    }

    @GetMapping("/activos/apartamento/{apartamentoId}")
    public ResponseEntity<List<ContratoArriendoModel>> obtenerActivosPorApartamentoId(@PathVariable UUID apartamentoId) {
        List<ContratoArriendoModel> contratos = contratoService.obtenerActivosPorApartamentoId(apartamentoId);
        return ResponseEntity.ok(contratos);
    }

    @GetMapping("/activos/arrendatario/{arrendatarioId}")
    public ResponseEntity<List<ContratoArriendoModel>> obtenerActivosPorArrendatarioId(@PathVariable UUID arrendatarioId) {
        List<ContratoArriendoModel> contratos = contratoService.obtenerActivosPorArrendatarioId(arrendatarioId);
        return ResponseEntity.ok(contratos);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ContratoArriendoModel> actualizar(@PathVariable UUID id, @RequestBody ContratoArriendoModel contratoActualizado) {
        Optional<ContratoArriendoModel> contratoExistente = contratoService.obtenerPorId(id);
        if (contratoExistente.isPresent()) {
            ContratoArriendoModel contrato = contratoExistente.get();
            contrato.setApartamento(contratoActualizado.getApartamento());
            contrato.setArrendatario(contratoActualizado.getArrendatario());
            contrato.setFechaInicio(contratoActualizado.getFechaInicio());
            contrato.setFechaFin(contratoActualizado.getFechaFin());
            contrato.setActivo(contratoActualizado.getActivo());
            ContratoArriendoModel contratoGuardado = contratoService.guardar(contrato);
            return ResponseEntity.ok(contratoGuardado);
        }
        return ResponseEntity.notFound().build();
    }

    @PutMapping("/{id}/activar")
    public ResponseEntity<ContratoArriendoModel> activar(@PathVariable UUID id) {
        ContratoArriendoModel contrato = contratoService.activar(id);
        return contrato != null ? ResponseEntity.ok(contrato) : ResponseEntity.notFound().build();
    }

    @PutMapping("/{id}/desactivar")
    public ResponseEntity<ContratoArriendoModel> desactivar(@PathVariable UUID id) {
        ContratoArriendoModel contrato = contratoService.desactivar(id);
        return contrato != null ? ResponseEntity.ok(contrato) : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable UUID id) {
        if (contratoService.obtenerPorId(id).isPresent()) {
            contratoService.eliminarPorId(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/contar")
    public ResponseEntity<Long> contar() {
        long total = contratoService.contar();
        return ResponseEntity.ok(total);
    }
}
