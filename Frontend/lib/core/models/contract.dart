class Contract {
  final String id;
  final String tenantId;
  final String tenantName;
  final String apartamento;
  final String apartamentoId;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final double montoMensual;
  final String estado;
  final String documento;

  Contract({
    required this.id,
    required this.tenantId,
    required this.tenantName,
    required this.apartamento,
    required this.apartamentoId,
    required this.fechaInicio,
    this.fechaFin,
    required this.montoMensual,
    required this.estado,
    required this.documento,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    // Función auxiliar para convertir valores a String
    String _toString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is Map) return json.toString();
      return value.toString();
    }

    // Función auxiliar para convertir valores a double
    double _toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0;
      return 0;
    }

    // Extraer tenantId desde la estructura anidada
    String extractTenantId() {
      // Intentar desde apartamento.arrendatario.id
      if (json['arrendatario'] is Map) {
        final arrendatario =
            json['arrendatario'] as Map<String, dynamic>;
        if (arrendatario['id'] != null) {
          return _toString(arrendatario['id']);
        }
      }
      // Fallback: usar tenantId directo si existe
      return _toString(json['tenantId']);
    }

    // Extraer tenantName desde la estructura anidada
    String extractTenantName() {
      // Intentar desde apartamento.arrendatario.nombre

        if (json['arrendatario'] is Map) {
          final arrendatario =
              json['arrendatario'] as Map<String, dynamic>;
          if (arrendatario['nombre'] != null) {
            return _toString(arrendatario['nombre']);
          }
        }
      // Fallback
      return _toString(json['tenantName'] ?? json['arrendatario']);
    }

    // Extraer número de apartamento
    String extractApartamento() {
      if (json['apartamento'] is Map) {
        final apartamento = json['apartamento'] as Map<String, dynamic>;
        if (apartamento['apartamento'] is Map) {
          final apt = apartamento['apartamento'] as Map<String, dynamic>;
          return _toString(apt['piso'] ?? '');
        }
        return _toString(apartamento['piso'] ?? '');
      }
      return _toString(json['apartamento']);
    }

    String extractApartamentoId() {
      if (json['apartamento'] is Map) {
        final apartamento = json['apartamento'] as Map<String, dynamic>;
        if (apartamento['id'] is Map) {
          final apt = apartamento['apartamento'] as Map<String, dynamic>;
          return _toString(apt['id'] ?? '');
        }
        return _toString(apartamento['id'] ?? '');
      }
      return _toString(json['apartamento']);
    }

    String _normalizeBool(dynamic value) {
      if (value == null) return '';
      if (value is bool) return value ? 'true' : 'false';
      final normalized = value.toString().toLowerCase().trim();
      if (normalized == 'true' || normalized == '1' || normalized == 'activo' || normalized == 'vigente') {
        return 'true';
      }
      if (normalized == 'false' || normalized == '0' || normalized == 'inactivo' || normalized == 'vencido') {
        return 'false';
      }
      return '';
    }

    return Contract(
      id: _toString(json['id']),
      tenantId: extractTenantId(),
      tenantName: extractTenantName(),
      apartamento: extractApartamento(),
      apartamentoId: extractApartamentoId(),
      fechaInicio: json['fechaInicio'] != null
          ? DateTime.parse(json['fechaInicio'].toString())
          : DateTime.now(),
      fechaFin: json['fechaFin'] != null
          ? DateTime.parse(json['fechaFin'].toString())
          : null,
      montoMensual: _toDouble(json['montoMensual']),
      estado: _normalizeBool(json['activo'] ?? json['estado']),
      documento: _toString(json['documento']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenantId': tenantId,
      'tenantName': tenantName,
      'apartamento': apartamento,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin?.toIso8601String(),
      'montoMensual': montoMensual,
      'estado': estado,
      'documento': documento,
    };
  }
}
