package com.example.martinez.controller;

import com.example.martinez.models.PagoMensualModel;
import com.example.martinez.service.PagoMensualService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/pagos")
@CrossOrigin(origins = "*", maxAge = 3600)
public class PagoMensualController {

    private final PagoMensualService pagoService;

    public PagoMensualController(PagoMensualService pagoService) {
        this.pagoService = pagoService;
    }

    @PostMapping
    public ResponseEntity<PagoMensualModel> crear(@RequestBody PagoMensualModel pago) {
        PagoMensualModel pagoGuardado = pagoService.guardar(pago);
        return ResponseEntity.status(HttpStatus.CREATED).body(pagoGuardado);
    }

    @GetMapping
    public ResponseEntity<List<PagoMensualModel>> obtenerTodos() {
        List<PagoMensualModel> pagos = pagoService.obtenerTodos();
        return ResponseEntity.ok(pagos);
    }

    @GetMapping("/{id}")
    public ResponseEntity<PagoMensualModel> obtenerPorId(@PathVariable UUID id) {
        Optional<PagoMensualModel> pago = pagoService.obtenerPorId(id);
        return pago.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/contrato/{contratoId}")
    public ResponseEntity<List<PagoMensualModel>> obtenerPorContratoId(@PathVariable UUID contratoId) {
        List<PagoMensualModel> pagos = pagoService.obtenerPorContratoId(contratoId);
        return ResponseEntity.ok(pagos);
    }

    @GetMapping("/contrato/{contratoId}/anio/{anio}")
    public ResponseEntity<List<PagoMensualModel>> obtenerPorContratoIdYAnio(@PathVariable UUID contratoId, @PathVariable Integer anio) {
        List<PagoMensualModel> pagos = pagoService.obtenerPorContratoIdYAnio(contratoId, anio);
        return ResponseEntity.ok(pagos);
    }

    @GetMapping("/contrato/{contratoId}/mes/{mes}/anio/{anio}")
    public ResponseEntity<PagoMensualModel> obtenerPorContratoMesAnio(@PathVariable UUID contratoId, @PathVariable Integer mes, @PathVariable Integer anio) {
        Optional<PagoMensualModel> pago = pagoService.obtenerPorContratoMesAnio(contratoId, mes, anio);
        return pago.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/pendientes")
    public ResponseEntity<List<PagoMensualModel>> obtenerPendientes() {
        List<PagoMensualModel> pagos = pagoService.obtenerPendientes();
        return ResponseEntity.ok(pagos);
    }

    @GetMapping("/realizados")
    public ResponseEntity<List<PagoMensualModel>> obtenerRealizados() {
        List<PagoMensualModel> pagos = pagoService.obtenerRealizados();
        return ResponseEntity.ok(pagos);
    }

    @GetMapping("/contrato/{contratoId}/pendientes")
    public ResponseEntity<List<PagoMensualModel>> obtenerPendientesPorContratoId(@PathVariable UUID contratoId) {
        List<PagoMensualModel> pagos = pagoService.obtenerPendientesPorContratoId(contratoId);
        return ResponseEntity.ok(pagos);
    }

    @PutMapping("/{id}")
    public ResponseEntity<PagoMensualModel> actualizar(@PathVariable UUID id, @RequestBody PagoMensualModel pagoActualizado) {
        Optional<PagoMensualModel> pagoExistente = pagoService.obtenerPorId(id);
        if (pagoExistente.isPresent()) {
            PagoMensualModel pago = pagoExistente.get();
            pago.setMes(pagoActualizado.getMes());
            pago.setAnio(pagoActualizado.getAnio());
            pago.setValorArriendo(pagoActualizado.getValorArriendo());
            pago.setValorAdministracion(pagoActualizado.getValorAdministracion());
            pago.setTotalNeto(pagoActualizado.getTotalNeto());
            pago.setFechaPago(pagoActualizado.getFechaPago());
            PagoMensualModel pagoGuardado = pagoService.guardar(pago);
            return ResponseEntity.ok(pagoGuardado);
        }
        return ResponseEntity.notFound().build();
    }

    @PutMapping("/{id}/marcar-pagado")
    public ResponseEntity<PagoMensualModel> marcarComoPagado(@PathVariable UUID id, @RequestParam LocalDate fechaPago) {
        PagoMensualModel pago = pagoService.marcarComoPagado(id, fechaPago);
        return pago != null ? ResponseEntity.ok(pago) : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable UUID id) {
        if (pagoService.obtenerPorId(id).isPresent()) {
            pagoService.eliminarPorId(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/contar")
    public ResponseEntity<Long> contar() {
        long total = pagoService.contar();
        return ResponseEntity.ok(total);
    }
}
