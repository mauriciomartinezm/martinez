class Tenant {
  final String id;
  final String nombre;
  final String email;
  final String telefono;
  final String apartamento;
  final DateTime fechaInicio;
  final String estado;

  Tenant({
    required this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.apartamento,
    required this.fechaInicio,
    required this.estado,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      telefono: json['telefono'] ?? '',
      apartamento: json['apartamento'] ?? '',
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
      'apartamento': apartamento,
      'fechaInicio': fechaInicio.toIso8601String(),
      'estado': estado,
    };
  }
}
