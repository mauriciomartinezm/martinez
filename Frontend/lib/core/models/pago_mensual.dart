import 'contrato_arriendo.dart';

class PagoMensual {
  final String id;
  final String mes;
  final String anio;
  final String tipo;
  final double valorArriendo;
  final double cuotaAdministracion;
  final double? fondoInmueble;
  final double totalNeto;
  final String? fechaPago;
  final ContratoArriendo contratoArriendo;

  PagoMensual({
    required this.id,
    required this.mes,
    required this.anio,
    required this.tipo,
    required this.valorArriendo,
    required this.cuotaAdministracion,
    this.fondoInmueble,
    required this.totalNeto,
    this.fechaPago,
    required this.contratoArriendo,
  });

  factory PagoMensual.fromJson(Map<String, dynamic> json) {
    return PagoMensual(
      id: json['id'] ?? '',
      mes: json['mes'] ?? '',
      anio: json['anio'] ?? '',
      tipo: json['tipo'] ?? '',
      valorArriendo: (json['valorArriendo'] as num?)?.toDouble() ?? 0.0,
      cuotaAdministracion: (json['cuotaAdministracion'] as num?)?.toDouble() ?? 0.0,
      fondoInmueble: (json['fondoInmueble'] as num?)?.toDouble(),
      totalNeto: (json['totalNeto'] as num?)?.toDouble() ?? 0.0,
      fechaPago: json['fechaPago'],
      contratoArriendo: ContratoArriendo.fromJson(json['contratoArriendo'] ?? {}),
    );
  }
}
