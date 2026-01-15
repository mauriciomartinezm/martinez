import 'package:flutter/material.dart';
import '../controllers/tenants_controller.dart';
import '../../../core/models/tenant.dart';
import '../../../core/models/contract.dart';
import '../../../core/models/pago_mensual.dart';
import '../../../core/services/api_service.dart';
import '../widgets/tenant_detail_bottom_sheet.dart';
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
      ]);
      _allContracts = results[0] as List<Contract>;
      _allPayments = results[1] as List<PagoMensual>;
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
        .where((tenant) =>
            tenant.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            tenant.apartamento
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  bool _isTenantActive(Tenant tenant) {
    // Un arrendatario está activo si tiene al menos un contrato activo
    return _allContracts.any((contract) =>
        contract.tenantId == tenant.id && contract.estado == 'true');
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Arrendatarios'),
            backgroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: _controller.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
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
                          Icon(Icons.person_outline,
                              size: 64,
                              color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'No hay arrendatarios',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
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
                              ? const Center(
                                  child: CircularProgressIndicator())
                              : RefreshIndicator(
                                  onRefresh: () =>
                                      _controller.refreshTenants(context),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    itemCount: _filteredTenants.length,
                                    itemBuilder: (context, index) {
                                      final tenant = _filteredTenants[index];
                                      return _TenantCard(
                                        tenant: tenant,
                                        isActive: _isTenantActive(tenant),
                                        onTap: () =>
                                            _showTenantDetails(tenant),
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

class _TenantCard extends StatelessWidget {
  final Tenant tenant;
  final bool isActive;
  final VoidCallback onTap;

  const _TenantCard({
    required this.tenant,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tenant.nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tenant.apartamento,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6F6F6F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isActive ? 'activo' : 'inactivo',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isActive
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.email_outlined,
                      size: 16, color: Color(0xFF6F6F6F)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tenant.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6F6F6F),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.phone_outlined,
                      size: 16, color: Color(0xFF6F6F6F)),
                  const SizedBox(width: 8),
                  Text(
                    tenant.telefono,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6F6F6F),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
