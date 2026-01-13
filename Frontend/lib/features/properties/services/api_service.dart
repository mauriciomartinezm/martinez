import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/building.dart';
import '../models/apartment.dart';

Future<List<Building>> fetchBuildings() async {
  final response = await http.get(Uri.parse('http://localhost:8080/edificios'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((building) => Building.fromJson(building)).toList();
  } else {
    throw Exception('Failed to load buildings');
  }
}

Future<List<Apartment>> fetchApartments() async {
  final response = await http.get(Uri.parse('http://localhost:8080/apartamentos'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((apartment) => Apartment.fromJson(apartment)).toList();
  } else {
    throw Exception('Failed to load apartments');
  }
}