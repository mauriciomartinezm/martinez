class Tenant {
  final String id;
  final String nombre;
  final String email;
  final String telefono;
  final DateTime fechaInicio;
  final String estado;

  Tenant({
    required this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.fechaInicio,
    required this.estado,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      telefono: json['telefono'] ?? '',
      fechaInicio: json['fechaInicio'] != null 
          ? DateTime.parse(json['fechaInicio'])
          : DateTime.now(),
      estado: json['estado'] ?? 'activo',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'fechaInicio': fechaInicio.toIso8601String(),
      'estado': estado,
    };
  }
}
