import 'package:flutter/material.dart';
import '../controllers/contracts_controller.dart';
import '../../../core/models/contract.dart';
import '../widgets/contract_detail_bottom_sheet.dart';

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({super.key});

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  late ContractsController _controller;
  String _searchQuery = '';
  String _filterStatus = 'todos';

  @override
  void initState() {
    super.initState();
    _controller = ContractsController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadContracts();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Contract> get _filteredContracts {
    var filtered = _controller.contracts;

    // Filtro por estado
    if (_filterStatus != 'todos') {
      filtered = filtered.where((contract) => contract.estado == _filterStatus).toList();
    }

    // Filtro por búsqueda
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((contract) =>
              contract.tenantName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              contract.apartamento
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  void _showContractDetails(Contract contract) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ContractDetailBottomSheet(
        contract: contract,
        onDownloadPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Descargando contrato...')),
          );
          // TODO: Implementar descarga
        },
        onRenewPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Abriendo renovación...')),
          );
          // TODO: Implementar renovación
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
            title: const Text('Contratos'),
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
                        onPressed: _controller.loadContracts,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _controller.contracts.isEmpty && !_controller.isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.description_outlined,
                              size: 64,
                              color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'No hay contratos',
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
                        // Search and filter
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Buscar contrato...',
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
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildFilterChip('Todos', 'todos'),
                                    const SizedBox(width: 8),
                                    _buildFilterChip('Vigentes', 'vigente'),
                                    const SizedBox(width: 8),
                                    _buildFilterChip('Vencidos', 'vencido'),
                                    const SizedBox(width: 8),
                                    _buildFilterChip('Suspendido', 'suspendido'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Contracts list
                        Expanded(
                          child: _controller.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator())
                              : RefreshIndicator(
                                  onRefresh: () =>
                                      _controller.refreshContracts(context),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    itemCount: _filteredContracts.length,
                                    itemBuilder: (context, index) {
                                      final contract = _filteredContracts[index];
                                      return _ContractCard(
                                        contract: contract,
                                        controller: _controller,
                                        onTap: () =>
                                            _showContractDetails(contract),
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

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = value;
        });
      },
      backgroundColor:
          isSelected ? const Color(0xFF1976D2) : const Color(0xFFF5F5F5),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _ContractCard extends StatelessWidget {
  final Contract contract;
  final ContractsController controller;
  final VoidCallback onTap;

  const _ContractCard({
    required this.contract,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isExpiringSoon = controller.isContractExpiringSoon(contract);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isExpiringSoon ? Colors.orange : const Color(0xFFE0E0E0),
            width: isExpiringSoon ? 2 : 1,
          ),
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
                          contract.tenantName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          contract.apartamento,
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
                      color: contract.estado == 'vigente'
                          ? Colors.green.withOpacity(0.1)
                          : contract.estado == 'vencido'
                              ? Colors.red.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      contract.estado,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: contract.estado == 'vigente'
                            ? Colors.green
                            : contract.estado == 'vencido'
                                ? Colors.red
                                : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.attach_money,
                          size: 16, color: Color(0xFF6F6F6F)),
                      const SizedBox(width: 8),
                      Text(
                        controller.formatCurrency(contract.montoMensual),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (contract.fechaFin != null)
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: Color(0xFF6F6F6F)),
                        const SizedBox(width: 8),
                        Text(
                          controller.formatDate(contract.fechaFin!),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6F6F6F),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              if (isExpiringSoon) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning, size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        'Vence en ${controller.getDaysUntilExpiration(contract)} días',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
