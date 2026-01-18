import 'package:flutter/material.dart';
import 'package:martinez/core/theme/app_colors.dart';
import '../../../core/models/contract.dart';
import '../controllers/contracts_controller.dart';

class ContractCard extends StatelessWidget {
  final Contract contract;
  final ContractsController controller;

  const ContractCard({
    super.key,
    required this.contract,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isExpiringSoon = controller.isContractExpiringSoon(contract);
    final qualifiesForIncrease = controller.tenantQualifiesForIncrease(contract);

    return GestureDetector(
      child: Card(
        color: AppColors.card,
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
                          controller.getApartmentInfo(contract),
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
                      color: contract.estado == 'true'
                          ? Colors.green.withOpacity(0.1)
                          : contract.estado == 'false'
                              ? Colors.red.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      contract.estado == 'true'
                          ? 'Vigente'
                          : 'Vencido',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: contract.estado == 'true'
                            ? Colors.green
                            : contract.estado == 'false'
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
                      const Icon(Icons.calendar_today,
                          size: 16, color: Color(0xFF6F6F6F)),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Inicio',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF999999),
                            ),
                          ),
                          Text(
                            controller.formatDate(contract.fechaInicio),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6F6F6F),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (contract.fechaFin != null)
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: Color(0xFF6F6F6F)),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Fin',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF999999),
                              ),
                            ),
                            Text(
                              controller.formatDate(contract.fechaFin!),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6F6F6F),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
              if (qualifiesForIncrease) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.trending_up, size: 14, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        'Aplica aumento anual',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
