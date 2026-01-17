import 'package:flutter/material.dart';
import 'package:martinez/core/theme/app_colors.dart';
import '../../../core/models/pago_mensual.dart';
import '../controllers/tenant_payments_controller.dart';

class PaymentCard extends StatelessWidget {
  final PagoMensual pago;
  final TenantPaymentsController controller;
  final PagoMensual? previousPayment;

  const PaymentCard({
    super.key, 
    required this.pago, 
    required this.controller,
    this.previousPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
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
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pago.tipo,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pago.contratoArriendo.arrendatario.nombre,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
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
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Arriendo',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                Row(
                  children: [
                    if (controller.isPaymentMissingIncrease(pago, previousPayment))
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.orange.withOpacity(0.4)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 10,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Aumento pendiente',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (previousPayment != null && 
                        previousPayment!.valorArriendo > 0 &&
                        pago.valorArriendo != previousPayment!.valorArriendo)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getPercentageColor(pago.valorArriendo, previousPayment!.valorArriendo).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getPercentageIcon(pago.valorArriendo, previousPayment!.valorArriendo),
                              size: 10,
                              color: _getPercentageColor(pago.valorArriendo, previousPayment!.valorArriendo),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${_calculatePercentageChange(pago.valorArriendo, previousPayment!.valorArriendo).abs().toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _getPercentageColor(pago.valorArriendo, previousPayment!.valorArriendo),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Text(
                      controller.formatCurrency(pago.valorArriendo),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ],
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
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Fecha de pago: ${pago.fechaPago}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
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

  double _calculatePercentageChange(double current, double previous) {
    if (previous == 0) return 0;
    return ((current - previous) / previous) * 100;
  }

  Color _getPercentageColor(double current, double previous) {
    return current > previous ? Colors.green : Colors.red;
  }

  IconData _getPercentageIcon(double current, double previous) {
    return current > previous ? Icons.arrow_upward : Icons.arrow_downward;
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
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
