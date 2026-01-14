import 'building.dart';

class Apartment {
  final bool activa;
  final Building edificio;
  final String id;
  final String piso;

  Apartment({required this.activa, required this.edificio, required this.id, required this.piso});

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      activa: json['activa'],
      edificio: Building.fromJson(json['edificio']),
      id: json['id'],
      piso: json['piso'],
    );
  }

  toJson() {}
}