import 'apartment.dart';

class ContratoArriendo {
  final String id;
  final bool activo;
  final Apartment apartamento;
  final Arrendatario arrendatario;
  final String fechaInicio;
  final String fechaFin;

  ContratoArriendo({
    required this.id,
    required this.activo,
    required this.apartamento,
    required this.arrendatario,
    required this.fechaInicio,
    required this.fechaFin,
  });

  factory ContratoArriendo.fromJson(Map<String, dynamic> json) {
    return ContratoArriendo(
      id: json['id'] ?? '',
      activo: json['activo'] ?? false,
      apartamento: Apartment.fromJson(json['apartamento'] ?? {}),
      arrendatario: Arrendatario.fromJson(json['arrendatario'] ?? {}),
      fechaInicio: json['fechaInicio'] ?? '',
      fechaFin: json['fechaFin'] ?? '',
    );
  }
}

class Arrendatario {
  final String id;
  final String nombre;
  final String? correo;
  final String? telefono;

  Arrendatario({
    required this.id,
    required this.nombre,
    this.correo,
    this.telefono,
  });

  factory Arrendatario.fromJson(Map<String, dynamic> json) {
    return Arrendatario(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      correo: json['correo'],
      telefono: json['telefono'],
    );
  }
}
