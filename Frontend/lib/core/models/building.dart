class Building {
  final String direccion;
  final String id;
  final String nombre;

  Building({required this.direccion, required this.id, required this.nombre});

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      direccion: json['direccion'],
      id: json['id'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'direccion': direccion,
      'id': id,
      'nombre': nombre,
    };
  }
}