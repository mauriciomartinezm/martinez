import 'package:flutter/material.dart';
import 'package:martinez/core/theme/app_colors.dart';
import 'package:martinez/features/tenants/controllers/tenants_controller.dart';
import '../../../core/models/tenant.dart';

class TenantDetailBottomSheet extends StatelessWidget {
  final Tenant tenant;
  final VoidCallback onPaymentsPressed;
  final VoidCallback onContractsPressed;
  final TenantsController controller;

  const TenantDetailBottomSheet({
    super.key,
    required this.tenant,
    required this.onPaymentsPressed,
    required this.onContractsPressed,
    required this.controller,
  });

  String _getApartmentInfo() {
    return controller.getApartmentInfo(tenant);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
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
                      tenant.nombre,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getApartmentInfo(),

                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
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

            // Contact info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(
                    'Email',
                    tenant.email.isEmpty ? 'No proporcionado' : tenant.email,
                  ),
                  const SizedBox(height: 12),
                  _infoRow(
                    'Teléfono',
                    tenant.telefono.isEmpty
                        ? 'No proporcionado'
                        : tenant.telefono,
                  ),
                  const SizedBox(height: 12),
                  _infoRow(
                    'Estado',
                    tenant.estado,
                    statusColor: tenant.estado == 'activo'
                        ? Colors.green
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
                    onPressed: onPaymentsPressed,
                    icon: const Icon(Icons.receipt_long),
                    label: const Text('PAGOS'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                /*
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onContractsPressed,
                    icon: const Icon(Icons.description),
                    label: const Text('CONTRATOS'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,

                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),*/
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
            color: AppColors.textSecondary,
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
              value.toUpperCase(),
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
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }

}
