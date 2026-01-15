import 'package:flutter/material.dart';
import '../../../core/models/tenant.dart';
import '../../../core/models/contract.dart';
import '../controllers/tenant_contracts_controller.dart';
import '../../contracts/widgets/contract_detail_bottom_sheet.dart';

class TenantContractsScreen extends StatefulWidget {
  final Tenant tenant;
  final List<Contract> allContracts;

  const TenantContractsScreen({
    super.key,
    required this.tenant,
    required this.allContracts,
  });

  @override
  State<TenantContractsScreen> createState() => _TenantContractsScreenState();
}

class _TenantContractsScreenState extends State<TenantContractsScreen> {
  late TenantContractsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TenantContractsController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadContracts(widget.tenant.id, widget.allContracts);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        },
        onRenewPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Abriendo renovación...')),
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
            title: Text('Contratos - ${widget.tenant.nombre}'),
            backgroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18,
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
                        onPressed: () =>
                            _controller.loadContracts(widget.tenant.id, widget.allContracts),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _controller.contracts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.description_outlined,
                                  size: 64, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text(
                                'No hay contratos registrados',
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
                            // Summary card
                            Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF388E3C),
                                    Color(0xFF2E7D32)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Resumen de contratos',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${_controller.getActiveContractsCount()}',
                                            style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Text(
                                            'Contratos vigentes',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            _controller.formatCurrency(
                                                _controller
                                                    .getTotalMonthlyAmount()),
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Text(
                                            'Mensual total',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Icon(Icons.description,
                                          size: 16, color: Colors.white70),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${_controller.contracts.length} contrato(s) en total',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Contracts list
                            Expanded(
                              child: ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: _controller.contracts.length,
                                itemBuilder: (context, index) {
                                  final contract = _controller.contracts[index];
                                  return _ContractCard(
                                    contract: contract,
                                    controller: _controller,
                                    onTap: () =>
                                        _showContractDetails(contract),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
        );
      },
    );
  }
}

class _ContractCard extends StatelessWidget {
  final Contract contract;
  final TenantContractsController controller;
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
                          contract.apartamento,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Desde ${controller.formatDate(contract.fechaInicio)}',
                          style: const TextStyle(
                            fontSize: 13,
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
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.attach_money,
                          size: 18, color: Color(0xFF6F6F6F)),
                      const SizedBox(width: 8),
                      Text(
                        controller.formatCurrency(contract.montoMensual),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        ' / mes',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6F6F6F),
                        ),
                      ),
                    ],
                  ),
                  if (contract.fechaFin != null)
                    Row(
                      children: [
                        const Icon(Icons.event,
                            size: 16, color: Color(0xFF6F6F6F)),
                        const SizedBox(width: 8),
                        Text(
                          controller.formatDate(contract.fechaFin!),
                          style: const TextStyle(
                            fontSize: 13,
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
