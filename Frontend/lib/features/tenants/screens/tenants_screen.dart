import 'package:flutter/material.dart';
import 'package:martinez/core/theme/app_colors.dart';
import '../controllers/tenants_controller.dart';
import '../../../core/models/tenant.dart';
import '../../../core/models/contract.dart';
import '../../../core/models/pago_mensual.dart';
import '../../../core/models/apartment.dart';
import '../../../core/services/api_service.dart';
import '../widgets/tenant_detail_bottom_sheet.dart';
import '../widgets/tenant_card.dart';
import 'tenant_payments_screen.dart';
import 'tenant_contracts_screen.dart';

class TenantsScreen extends StatefulWidget {
  const TenantsScreen({super.key});

  @override
  State<TenantsScreen> createState() => _TenantsScreenState();
}

class _TenantsScreenState extends State<TenantsScreen> {
  late TenantsController _controller;
  String _searchQuery = '';
  List<Contract> _allContracts = [];
  List<PagoMensual> _allPayments = [];
  List<Apartment> _allApartments = [];

  @override
  void initState() {
    super.initState();
    _controller = TenantsController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadTenants();
      _loadData();
    });
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        fetchContracts(),
        fetchPagos(),
        fetchApartments(),
      ]);
      _allContracts = results[0] as List<Contract>;
      _allPayments = results[1] as List<PagoMensual>;
      _allApartments = results[2] as List<Apartment>;
      _controller.setData(_allContracts, _allApartments);
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // Error al cargar datos
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Tenant> get _filteredTenants {
    if (_searchQuery.isEmpty) {
      return _controller.tenants;
    }
    return _controller.tenants
        .where(
          (tenant) =>
              tenant.nombre.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  bool _isTenantActive(Tenant tenant) {
    // Un arrendatario está activo si tiene al menos un contrato activo
    return _allContracts.any(
      (contract) => contract.tenantId == tenant.id && contract.estado == 'true',
    );
  }

  void _showTenantDetails(Tenant tenant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => TenantDetailBottomSheet(
        tenant: tenant,
        controller: _controller,

        onPaymentsPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TenantPaymentsScreen(
                tenant: tenant,
                allPayments: _allPayments,
                allContracts: _allContracts,
              ),
            ),
          );
        },
        onContractsPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TenantContractsScreen(
                tenant: tenant,
                allContracts: _allContracts,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,

          appBar: AppBar(
            title: const Text('Arrendatarios'),
            backgroundColor: AppColors.background,
            elevation: 0,
            titleTextStyle: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
          ),
          body: _controller.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(_controller.errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _controller.loadTenants,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _controller.tenants.isEmpty && !_controller.isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay arrendatarios',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Buscar arrendatario...',
                          fillColor: AppColors.card,

                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    // Tenants list
                    Expanded(
                      child: _controller.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : RefreshIndicator(
                              onRefresh: () =>
                                  _controller.refreshTenants(context),
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                itemCount: _filteredTenants.length,
                                itemBuilder: (context, index) {
                                  final tenant = _filteredTenants[index];
                                  return TenantCard(
                                    tenant: tenant,
                                    isActive: _isTenantActive(tenant),
                                    controller: _controller,
                                    onTap: () => _showTenantDetails(tenant),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
