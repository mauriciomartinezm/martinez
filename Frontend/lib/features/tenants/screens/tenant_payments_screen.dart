import 'package:flutter/material.dart';
import '../../../core/models/tenant.dart';
import '../../../core/models/pago_mensual.dart';
import '../../../core/models/contract.dart';
import '../controllers/tenant_payments_controller.dart';

class TenantPaymentsScreen extends StatefulWidget {
  final Tenant tenant;
  final List<PagoMensual> allPayments;
  final List<Contract> allContracts;

  const TenantPaymentsScreen({
    super.key,
    required this.tenant,
    required this.allPayments,
    required this.allContracts,
  });

  @override
  State<TenantPaymentsScreen> createState() => _TenantPaymentsScreenState();
}

class _TenantPaymentsScreenState extends State<TenantPaymentsScreen> {
  late TenantPaymentsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TenantPaymentsController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadPayments(
        widget.tenant.id,
        widget.allPayments,
        widget.allContracts,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Pagos - ${widget.tenant.nombre}'),
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
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(_controller.errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _controller.loadPayments(
                          widget.tenant.id,
                          widget.allPayments,
                          widget.allContracts,
                        ),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _controller.payments.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay pagos registrados',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
                          colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total pagado',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _controller.formatCurrency(
                              _controller.getTotalPaid(),
                            ),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_controller.firstContract != null) ...[
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Primer contrato el ${_controller.formatDate(_controller.firstContract!.fechaInicio)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            if (_controller.latestContract != null &&
                                _controller.firstContract!.id !=
                                    _controller.latestContract!.id) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.file_copy_outlined,
                                    size: 16,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Último contrato ${_controller.formatDate(_controller.latestContract!.fechaInicio)} hasta ${_controller.formatDate(_controller.latestContract!.fechaFin!)} ',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            /*
                                    if (_controller.latestContract?.fechaFin != null) ...[
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today_outlined,
                                              size: 16, color: Colors.white70),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Hasta ${_controller.formatDate(_controller.latestContract!.fechaFin!)}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],*/
                            if (_controller.getIncreaseDate() != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.trending_up,
                                    size: 16,
                                    color: Colors.orangeAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Se debió hacer aumento el ${_controller.formatDate(_controller.getIncreaseDate()!)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.orangeAccent,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (_controller.getNextIncreaseDate() != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 16,
                                    color: Colors.lightBlueAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Se deberá hacer aumento el ${_controller.formatDate(_controller.getNextIncreaseDate()!)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.lightBlueAccent,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 8),
                          ],
                          Row(
                            children: [
                              const Icon(
                                Icons.receipt,
                                size: 16,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_controller.payments.length} pagos registrados en total',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.receipt,
                                size: 16,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_controller.getPaymentsSinceContract()} pago(s) en el ciclo actual',
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
                    // Payments list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _controller.payments.length,
                        itemBuilder: (context, index) {
                          final pago = _controller.payments[index];
                          return _PaymentCard(
                            pago: pago,
                            controller: _controller,
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

class _PaymentCard extends StatelessWidget {
  final PagoMensual pago;
  final TenantPaymentsController controller;

  const _PaymentCard({required this.pago, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${pago.mes} ${pago.anio}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pago.tipo,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6F6F6F),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.formatCurrency(pago.totalNeto),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _DetailRow(
              label: 'Arriendo',
              value: controller.formatCurrency(pago.valorArriendo),
            ),
            const SizedBox(height: 8),
            _DetailRow(
              label: 'Administración',
              value: controller.formatCurrency(pago.cuotaAdministracion),
            ),
            if (pago.fondoInmueble != null && pago.fondoInmueble! > 0) ...[
              const SizedBox(height: 8),
              _DetailRow(
                label: 'Fondo inmueble',
                value: controller.formatCurrency(pago.fondoInmueble!),
              ),
            ],
            if (pago.fechaPago != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Color(0xFF6F6F6F),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Fecha de pago: ${pago.fechaPago}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6F6F6F),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF6F6F6F)),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
