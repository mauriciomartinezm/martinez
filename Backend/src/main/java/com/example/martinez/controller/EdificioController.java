package com.example.martinez.controller;

import com.example.martinez.models.EdificioModel;
import com.example.martinez.service.EdificioService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/edificios")
@CrossOrigin(origins = "*", maxAge = 3600)
public class EdificioController {

    private final EdificioService edificioService;

    public EdificioController(EdificioService edificioService) {
        this.edificioService = edificioService;
    }

    @PostMapping
    public ResponseEntity<EdificioModel> crear(@RequestBody EdificioModel edificio) {
        EdificioModel edificioGuardado = edificioService.guardar(edificio);
        return ResponseEntity.status(HttpStatus.CREATED).body(edificioGuardado);
    }

    @GetMapping
    public ResponseEntity<List<EdificioModel>> obtenerTodos() {
        List<EdificioModel> edificios = edificioService.obtenerTodos();
        return ResponseEntity.ok(edificios);
    }

    @GetMapping("/{id}")
    public ResponseEntity<EdificioModel> obtenerPorId(@PathVariable UUID id) {
        Optional<EdificioModel> edificio = edificioService.obtenerPorId(id);
        return edificio.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/buscar/nombre")
    public ResponseEntity<List<EdificioModel>> buscarPorNombre(@RequestParam String nombre) {
        List<EdificioModel> edificios = edificioService.buscarPorNombre(nombre);
        return ResponseEntity.ok(edificios);
    }

    @GetMapping("/buscar/direccion")
    public ResponseEntity<List<EdificioModel>> buscarPorDireccion(@RequestParam String direccion) {
        List<EdificioModel> edificios = edificioService.buscarPorDireccion(direccion);
        return ResponseEntity.ok(edificios);
    }

    @PutMapping("/{id}")
    public ResponseEntity<EdificioModel> actualizar(@PathVariable UUID id, @RequestBody EdificioModel edificioActualizado) {
        Optional<EdificioModel> edificioExistente = edificioService.obtenerPorId(id);
        if (edificioExistente.isPresent()) {
            EdificioModel edificio = edificioExistente.get();
            edificio.setNombre(edificioActualizado.getNombre());
            edificio.setDireccion(edificioActualizado.getDireccion());
            EdificioModel edificioGuardado = edificioService.guardar(edificio);
            return ResponseEntity.ok(edificioGuardado);
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable UUID id) {
        if (edificioService.obtenerPorId(id).isPresent()) {
            edificioService.eliminarPorId(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/contar")
    public ResponseEntity<Long> contar() {
        long total = edificioService.contar();
        return ResponseEntity.ok(total);
    }
}
