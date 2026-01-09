package com.example.martinez.controller;

import com.example.martinez.models.UsuarioModel;
import com.example.martinez.service.UsuarioService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/usuarios")
@CrossOrigin(origins = "*", maxAge = 3600)
public class UsuarioController {

    private final UsuarioService usuarioService;

    public UsuarioController(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    @PostMapping
    public ResponseEntity<UsuarioModel> crear(@RequestBody UsuarioModel usuario) {
        UsuarioModel usuarioGuardado = usuarioService.guardar(usuario);
        return ResponseEntity.status(HttpStatus.CREATED).body(usuarioGuardado);
    }

    @GetMapping
    public ResponseEntity<List<UsuarioModel>> obtenerTodos() {
        List<UsuarioModel> usuarios = usuarioService.obtenerTodos();
        return ResponseEntity.ok(usuarios);
    }

    @GetMapping("/{id}")
    public ResponseEntity<UsuarioModel> obtenerPorId(@PathVariable UUID id) {
        Optional<UsuarioModel> usuario = usuarioService.obtenerPorId(id);
        return usuario.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/username/{username}")
    public ResponseEntity<UsuarioModel> obtenerPorUsername(@PathVariable String username) {
        Optional<UsuarioModel> usuario = usuarioService.obtenerPorUsername(username);
        return usuario.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    public ResponseEntity<UsuarioModel> actualizar(@PathVariable UUID id, @RequestBody UsuarioModel usuarioActualizado) {
        Optional<UsuarioModel> usuarioExistente = usuarioService.obtenerPorId(id);
        if (usuarioExistente.isPresent()) {
            UsuarioModel usuario = usuarioExistente.get();
            usuario.setUsername(usuarioActualizado.getUsername());
            usuario.setPassword(usuarioActualizado.getPassword());
            UsuarioModel usuarioGuardado = usuarioService.guardar(usuario);
            return ResponseEntity.ok(usuarioGuardado);
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable UUID id) {
        if (usuarioService.obtenerPorId(id).isPresent()) {
            usuarioService.eliminarPorId(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/contar")
    public ResponseEntity<Long> contar() {
        long total = usuarioService.contar();
        return ResponseEntity.ok(total);
    }
}
