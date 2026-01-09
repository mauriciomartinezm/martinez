package com.example.martinez.controller;

import com.example.martinez.models.ArrendatarioModel;
import com.example.martinez.service.ArrendatarioService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/arrendatarios")
@CrossOrigin(origins = "*", maxAge = 3600)
public class ArrendatarioController {

    private final ArrendatarioService arrendatarioService;

    public ArrendatarioController(ArrendatarioService arrendatarioService) {
        this.arrendatarioService = arrendatarioService;
    }

    @PostMapping
    public ResponseEntity<ArrendatarioModel> crear(@RequestBody ArrendatarioModel arrendatario) {
        ArrendatarioModel arrendatarioGuardado = arrendatarioService.guardar(arrendatario);
        return ResponseEntity.status(HttpStatus.CREATED).body(arrendatarioGuardado);
    }

    @GetMapping
    public ResponseEntity<List<ArrendatarioModel>> obtenerTodos() {
        List<ArrendatarioModel> arrendatarios = arrendatarioService.obtenerTodos();
        return ResponseEntity.ok(arrendatarios);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ArrendatarioModel> obtenerPorId(@PathVariable UUID id) {
        Optional<ArrendatarioModel> arrendatario = arrendatarioService.obtenerPorId(id);
        return arrendatario.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/correo/{correo}")
    public ResponseEntity<ArrendatarioModel> obtenerPorCorreo(@PathVariable String correo) {
        Optional<ArrendatarioModel> arrendatario = arrendatarioService.obtenerPorCorreo(correo);
        return arrendatario.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/telefono/{telefono}")
    public ResponseEntity<ArrendatarioModel> obtenerPorTelefono(@PathVariable String telefono) {
        Optional<ArrendatarioModel> arrendatario = arrendatarioService.obtenerPorTelefono(telefono);
        return arrendatario.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/buscar/nombre")
    public ResponseEntity<List<ArrendatarioModel>> buscarPorNombre(@RequestParam String nombre) {
        List<ArrendatarioModel> arrendatarios = arrendatarioService.buscarPorNombre(nombre);
        return ResponseEntity.ok(arrendatarios);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ArrendatarioModel> actualizar(@PathVariable UUID id, @RequestBody ArrendatarioModel arrendatarioActualizado) {
        Optional<ArrendatarioModel> arrendatarioExistente = arrendatarioService.obtenerPorId(id);
        if (arrendatarioExistente.isPresent()) {
            ArrendatarioModel arrendatario = arrendatarioExistente.get();
            arrendatario.setNombre(arrendatarioActualizado.getNombre());
            arrendatario.setTelefono(arrendatarioActualizado.getTelefono());
            arrendatario.setCorreo(arrendatarioActualizado.getCorreo());
            ArrendatarioModel arrendatarioGuardado = arrendatarioService.guardar(arrendatario);
            return ResponseEntity.ok(arrendatarioGuardado);
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable UUID id) {
        if (arrendatarioService.obtenerPorId(id).isPresent()) {
            arrendatarioService.eliminarPorId(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/contar")
    public ResponseEntity<Long> contar() {
        long total = arrendatarioService.contar();
        return ResponseEntity.ok(total);
    }
}
