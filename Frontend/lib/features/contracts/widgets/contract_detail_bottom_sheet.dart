import 'package:flutter/material.dart';
import '../../../core/models/contract.dart';

class ContractDetailBottomSheet extends StatelessWidget {
  final Contract contract;
  final VoidCallback onDownloadPressed;
  final VoidCallback onRenewPressed;

  const ContractDetailBottomSheet({
    super.key,
    required this.contract,
    required this.onDownloadPressed,
    required this.onRenewPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isExpiring = contract.estado == 'vigente' &&
        contract.fechaFin != null &&
        contract.fechaFin!.isBefore(DateTime.now().add(const Duration(days: 30)));

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contract.tenantName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Alert if expiring
            if (isExpiring)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Contrato próximo a vencer',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (isExpiring) const SizedBox(height: 20),

            // Contract details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('Monto mensual', '\$${contract.montoMensual.toStringAsFixed(0)}'),
                  const SizedBox(height: 12),
                  _infoRow('Fecha inicio', _formatDate(contract.fechaInicio)),
                  const SizedBox(height: 12),
                  if (contract.fechaFin != null)
                    _infoRow('Fecha fin', _formatDate(contract.fechaFin!))
                  else
                    _infoRow('Fecha fin', 'Indefinido'),
                  const SizedBox(height: 12),
                  _infoRow(
                    'Estado',
                    contract.estado,
                    statusColor: contract.estado == 'vigente'
                        ? Colors.green
                        : contract.estado == 'vencido'
                            ? Colors.red
                            : Colors.orange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onDownloadPressed,
                    icon: const Icon(Icons.download),
                    label: const Text('Descargar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onRenewPressed,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Renovar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF388E3C),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? statusColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6F6F6F),
            fontWeight: FontWeight.w500,
          ),
        ),
        if (statusColor != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
          )
        else
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
