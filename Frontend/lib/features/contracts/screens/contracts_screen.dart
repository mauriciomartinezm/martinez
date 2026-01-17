import 'package:flutter/material.dart';
import 'package:martinez/core/theme/app_colors.dart';
import '../controllers/contracts_controller.dart';
import '../../../core/models/contract.dart';
import '../widgets/contract_card.dart';
import '../widgets/contract_details_dialog.dart';

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

    // Ordenar por fecha de vencimiento (próximos a vencerse primero)
    filtered.sort((a, b) {
      if (a.fechaFin == null && b.fechaFin == null) return 0;
      if (a.fechaFin == null) return 1;
      if (b.fechaFin == null) return -1;
      return b.fechaFin!.compareTo(a.fechaFin!);
    });

    return filtered;
  }

  void _showContractDetails(Contract contract) {
    ContractDetailsDialog.show(context, contract);
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
                                      return ContractCard(
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
      backgroundColor: isSelected ? AppColors.primary : Colors.grey[200],
      selectedColor: AppColors.primary,
      side: isSelected 
          ? BorderSide.none 
          : BorderSide(color: Colors.grey[300]!),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
      ),
      showCheckmark: false,
    );
  }
}
