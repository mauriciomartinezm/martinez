package com.example.martinez.controller;

import com.example.martinez.models.ApartamentoModel;
import com.example.martinez.service.ApartamentoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/apartamentos")
@CrossOrigin(origins = "*", maxAge = 3600)
public class ApartamentoController {

    private final ApartamentoService apartamentoService;

    public ApartamentoController(ApartamentoService apartamentoService) {
        this.apartamentoService = apartamentoService;
    }

    @PostMapping
    public ResponseEntity<ApartamentoModel> crear(@RequestBody ApartamentoModel apartamento) {
        ApartamentoModel apartamentoGuardado = apartamentoService.guardar(apartamento);
        return ResponseEntity.status(HttpStatus.CREATED).body(apartamentoGuardado);
    }

    @GetMapping
    public ResponseEntity<List<ApartamentoModel>> obtenerTodos() {
        List<ApartamentoModel> apartamentos = apartamentoService.obtenerTodos();
        return ResponseEntity.ok(apartamentos);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApartamentoModel> obtenerPorId(@PathVariable UUID id) {
        Optional<ApartamentoModel> apartamento = apartamentoService.obtenerPorId(id);
        return apartamento.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/edificio/{edificioId}")
    public ResponseEntity<List<ApartamentoModel>> obtenerPorEdificioId(@PathVariable UUID edificioId) {
        List<ApartamentoModel> apartamentos = apartamentoService.obtenerPorEdificioId(edificioId);
        return ResponseEntity.ok(apartamentos);
    }

    @GetMapping("/activos")
    public ResponseEntity<List<ApartamentoModel>> obtenerActivos() {
        List<ApartamentoModel> apartamentos = apartamentoService.obtenerActivos();
        return ResponseEntity.ok(apartamentos);
    }

    @GetMapping("/activos/edificio/{edificioId}")
    public ResponseEntity<List<ApartamentoModel>> obtenerActivosPorEdificioId(@PathVariable UUID edificioId) {
        List<ApartamentoModel> apartamentos = apartamentoService.obtenerActivosPorEdificioId(edificioId);
        return ResponseEntity.ok(apartamentos);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApartamentoModel> actualizar(@PathVariable UUID id, @RequestBody ApartamentoModel apartamentoActualizado) {
        Optional<ApartamentoModel> apartamentoExistente = apartamentoService.obtenerPorId(id);
        if (apartamentoExistente.isPresent()) {
            ApartamentoModel apartamento = apartamentoExistente.get();
            apartamento.setPiso(apartamentoActualizado.getPiso());
            apartamento.setEdificio(apartamentoActualizado.getEdificio());
            apartamento.setActiva(apartamentoActualizado.getActiva());
            ApartamentoModel apartamentoGuardado = apartamentoService.guardar(apartamento);
            return ResponseEntity.ok(apartamentoGuardado);
        }
        return ResponseEntity.notFound().build();
    }

    @PutMapping("/{id}/activar")
    public ResponseEntity<ApartamentoModel> activar(@PathVariable UUID id) {
        ApartamentoModel apartamento = apartamentoService.activar(id);
        return apartamento != null ? ResponseEntity.ok(apartamento) : ResponseEntity.notFound().build();
    }

    @PutMapping("/{id}/desactivar")
    public ResponseEntity<ApartamentoModel> desactivar(@PathVariable UUID id) {
        ApartamentoModel apartamento = apartamentoService.desactivar(id);
        return apartamento != null ? ResponseEntity.ok(apartamento) : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable UUID id) {
        if (apartamentoService.obtenerPorId(id).isPresent()) {
            apartamentoService.eliminarPorId(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/contar")
    public ResponseEntity<Long> contar() {
        long total = apartamentoService.contar();
        return ResponseEntity.ok(total);
    }
}
