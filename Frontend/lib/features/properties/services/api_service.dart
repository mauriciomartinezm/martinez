import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import '../../../core/models/building.dart';
import '../../../core/models/apartment.dart';

const String apiUrl = 'http://192.168.0.101:8080';

Future<List<Building>> fetchBuildings() async {
  debugPrint('Fetching buildings from API...');
  final response = await http.get(Uri.parse('$apiUrl/edificios'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((building) => Building.fromJson(building)).toList();
  } else {
    throw Exception('Failed to load buildings');
  }
}

Future<List<Apartment>> fetchApartments() async {
  debugPrint('Fetching apartments from API...');
  final response = await http.get(Uri.parse('$apiUrl/apartamentos'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((apartment) => Apartment.fromJson(apartment)).toList();
  } else {
    throw Exception('Failed to load apartments');
  }
}