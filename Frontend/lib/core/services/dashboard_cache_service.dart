import 'dart:convert';

class DashboardCacheService {
  /// Caché en memoria para las estadísticas del dashboard
  static Map<String, dynamic>? _cachedStats;

  /// Guarda las estadísticas del dashboard en caché (en memoria)
  static Future<void> saveStats(Map<String, dynamic> stats) async {
    try {
      _cachedStats = stats;
      print('Estadísticas guardadas en caché');
    } catch (e) {
      print('Error guardando caché: $e');
    }
  }

  /// Carga las estadísticas del caché (en memoria)
  static Future<Map<String, dynamic>?> loadStats() async {
    try {
      if (_cachedStats != null) {
        print('Estadísticas cargadas desde caché');
        return _cachedStats;
      }
    } catch (e) {
      print('Error cargando caché: $e');
    }
    return null;
  }

  /// Limpia el caché del dashboard
  static Future<void> clearStats() async {
    try {
      _cachedStats = null;
      print('Caché limpiado');
    } catch (e) {
      print('Error limpiando caché: $e');
    }
  }
}
