import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tenant.dart';
import '../models/contract.dart';
import '../models/apartment.dart';
import '../models/pago_mensual.dart';
import '../models/building.dart';
import '../services/api_service.dart';

/// Repositorio global con caché en memoria y persistencia local para todos los datos de la aplicación.
/// Implementa el patrón Singleton para garantizar una única fuente de verdad.
class DataRepository {
  DataRepository._();
  static final DataRepository instance = DataRepository._();

  // Cache de datos en memoria
  List<Tenant>? _tenants;
  List<Contract>? _contracts;
  List<Apartment>? _apartments;
  List<PagoMensual>? _payments;
  List<Building>? _buildings;

  // Keys para SharedPreferences
  static const String _tenantsKey = 'cached_tenants';
  static const String _contractsKey = 'cached_contracts';
  static const String _apartmentsKey = 'cached_apartments';
  static const String _paymentsKey = 'cached_payments';
  static const String _buildingsKey = 'cached_buildings';
  static const String _lastUpdateKey = 'last_update_timestamp';

  /// Indica si los datos actuales provienen de cache local (sin conexión)
  bool _isOfflineMode = false;
  bool get isOfflineMode => _isOfflineMode;

  /// Precarga todos los datos, primero desde cache local, solo carga de API si no hay datos guardados
  Future<void> preloadAll({bool forceRefresh = false}) async {
    // Si ya hay datos en memoria y no es refresh forzado, no hacer nada
    if (!forceRefresh && 
        _tenants != null && 
        _contracts != null && 
        _apartments != null && 
        _payments != null && 
        _buildings != null) {
      return;
    }

    // Primero intentar cargar desde cache local
    final hasLocalData = await _hasLocalData();
    
    if (hasLocalData && !forceRefresh) {
      // Si hay datos guardados, cargarlos y usarlos
      debugPrint('📦 Cargando datos desde cache local...');
      await _loadFromLocalCache();
      _isOfflineMode = false; // Tiene datos, pero no necesariamente está offline
      return;
    }

    // Solo si NO hay datos guardados, hacer peticiones a la API
    try {
      debugPrint('🌐 No hay datos locales, cargando desde API...');
      final results = await Future.wait([
        fetchTenants(),
        fetchContracts(),
        fetchApartments(),
        fetchPagos(),
        fetchBuildings(),
      ]);

      _tenants = results[0] as List<Tenant>;
      _contracts = results[1] as List<Contract>;
      _apartments = results[2] as List<Apartment>;
      _payments = results[3] as List<PagoMensual>;
      _buildings = results[4] as List<Building>;

      // Guardar en cache local
      await _saveToLocalCache();
      _isOfflineMode = false;
    } catch (e) {
      // Si falla la API y no había datos locales, propagar el error
      debugPrint('⚠️ Error al cargar desde API: $e');
      throw Exception('No se pudo cargar los datos y no hay cache local disponible');
    }
  }

  /// Verifica si hay datos guardados en SharedPreferences
  Future<bool> _hasLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_tenantsKey) &&
             prefs.containsKey(_contractsKey) &&
             prefs.containsKey(_apartmentsKey) &&
             prefs.containsKey(_paymentsKey) &&
             prefs.containsKey(_buildingsKey);
    } catch (e) {
      return false;
    }
  }

  /// Guarda todos los datos en cache local
  Future<void> _saveToLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_tenants != null) {
        final tenantsJson = jsonEncode(_tenants!.map((t) => t.toJson()).toList());
        await prefs.setString(_tenantsKey, tenantsJson);
      }
      
      if (_contracts != null) {
        final contractsJson = jsonEncode(_contracts!.map((c) => c.toJson()).toList());
        await prefs.setString(_contractsKey, contractsJson);
      }
      
      if (_apartments != null) {
        final apartmentsJson = jsonEncode(_apartments!.map((a) => a.toJson()).toList());
        await prefs.setString(_apartmentsKey, apartmentsJson);
      }
      
      if (_payments != null) {
        final paymentsJson = jsonEncode(_payments!.map((p) => p.toJson()).toList());
        await prefs.setString(_paymentsKey, paymentsJson);
      }
      
      if (_buildings != null) {
        final buildingsJson = jsonEncode(_buildings!.map((b) => b.toJson()).toList());
        await prefs.setString(_buildingsKey, buildingsJson);
      }

      // Guardar timestamp de última actualización
      await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
      
      debugPrint('✅ Datos guardados en cache local');
    } catch (e) {
      debugPrint('⚠️ Error al guardar en cache local: $e');
    }
  }

  /// Carga todos los datos desde cache local
  Future<void> _loadFromLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final tenantsJson = prefs.getString(_tenantsKey);
      if (tenantsJson != null) {
        final List<dynamic> decoded = jsonDecode(tenantsJson);
        _tenants = decoded.map((json) => Tenant.fromJson(json)).toList();
      }
      
      final contractsJson = prefs.getString(_contractsKey);
      if (contractsJson != null) {
        final List<dynamic> decoded = jsonDecode(contractsJson);
        _contracts = decoded.map((json) => Contract.fromJson(json)).toList();
      }
      
      final apartmentsJson = prefs.getString(_apartmentsKey);
      if (apartmentsJson != null) {
        final List<dynamic> decoded = jsonDecode(apartmentsJson);
        _apartments = decoded.map((json) => Apartment.fromJson(json)).toList();
      }
      
      final paymentsJson = prefs.getString(_paymentsKey);
      if (paymentsJson != null) {
        final List<dynamic> decoded = jsonDecode(paymentsJson);
        _payments = decoded.map((json) => PagoMensual.fromJson(json)).toList();
      }
      
      final buildingsJson = prefs.getString(_buildingsKey);
      if (buildingsJson != null) {
        final List<dynamic> decoded = jsonDecode(buildingsJson);
        _buildings = decoded.map((json) => Building.fromJson(json)).toList();
      }

      debugPrint('✅ Datos cargados desde cache local');
    } catch (e) {
      debugPrint('⚠️ Error al cargar desde cache local: $e');
      throw Exception('No hay datos disponibles offline');
    }
  }

  /// Obtiene la fecha de la última actualización desde la API
  Future<DateTime?> getLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastUpdateKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  // ============ TENANTS ============
  Future<List<Tenant>> getTenants({bool forceRefresh = false}) async {
    if (forceRefresh || _tenants == null) {
      try {
        _tenants = await fetchTenants();
        await _saveToLocalCache();
        _isOfflineMode = false;
      } catch (e) {
        debugPrint('⚠️ Error al cargar tenants desde API: $e');
        if (_tenants == null) {
          await _loadFromLocalCache();
          _isOfflineMode = true;
        }
      }
    }
    return _tenants!;
  }

  List<Tenant> get cachedTenants => _tenants ?? const [];

  // ============ CONTRACTS ============
  Future<List<Contract>> getContracts({bool forceRefresh = false}) async {
    if (forceRefresh || _contracts == null) {
      try {
        _contracts = await fetchContracts();
        await _saveToLocalCache();
        _isOfflineMode = false;
      } catch (e) {
        debugPrint('⚠️ Error al cargar contracts desde API: $e');
        if (_contracts == null) {
          await _loadFromLocalCache();
          _isOfflineMode = true;
        }
      }
    }
    return _contracts!;
  }

  List<Contract> get cachedContracts => _contracts ?? const [];

  // ============ APARTMENTS ============
  Future<List<Apartment>> getApartments({bool forceRefresh = false}) async {
    if (forceRefresh || _apartments == null) {
      try {
        _apartments = await fetchApartments();
        await _saveToLocalCache();
        _isOfflineMode = false;
      } catch (e) {
        debugPrint('⚠️ Error al cargar apartments desde API: $e');
        if (_apartments == null) {
          await _loadFromLocalCache();
          _isOfflineMode = true;
        }
      }
    }
    return _apartments!;
  }

  List<Apartment> get cachedApartments => _apartments ?? const [];

  // ============ PAYMENTS ============
  Future<List<PagoMensual>> getPayments({bool forceRefresh = false}) async {
    if (forceRefresh || _payments == null) {
      try {
        _payments = await fetchPagos();
        await _saveToLocalCache();
        _isOfflineMode = false;
      } catch (e) {
        debugPrint('⚠️ Error al cargar payments desde API: $e');
        if (_payments == null) {
          await _loadFromLocalCache();
          _isOfflineMode = true;
        }
      }
    }
    return _payments!;
  }

  List<PagoMensual> get cachedPayments => _payments ?? const [];

  // ============ BUILDINGS ============
  Future<List<Building>> getBuildings({bool forceRefresh = false}) async {
    if (forceRefresh || _buildings == null) {
      try {
        _buildings = await fetchBuildings();
        await _saveToLocalCache();
        _isOfflineMode = false;
      } catch (e) {
        debugPrint('⚠️ Error al cargar buildings desde API: $e');
        if (_buildings == null) {
          await _loadFromLocalCache();
          _isOfflineMode = true;
        }
      }
    }
    return _buildings!;
  }

  List<Building> get cachedBuildings => _buildings ?? const [];

  /// Limpia toda la caché (memoria y almacenamiento local)
  Future<void> clearCache() async {
    _tenants = null;
    _contracts = null;
    _apartments = null;
    _payments = null;
    _buildings = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tenantsKey);
    await prefs.remove(_contractsKey);
    await prefs.remove(_apartmentsKey);
    await prefs.remove(_paymentsKey);
    await prefs.remove(_buildingsKey);
    await prefs.remove(_lastUpdateKey);
  }

  /// Limpia la caché de un tipo específico de datos
  void clearTenantsCache() => _tenants = null;
  void clearContractsCache() => _contracts = null;
  void clearApartmentsCache() => _apartments = null;
  void clearPaymentsCache() => _payments = null;
  void clearBuildingsCache() => _buildings = null;
}
