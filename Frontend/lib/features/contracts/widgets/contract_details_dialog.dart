import 'package:flutter/material.dart';
import '../../../core/models/contract.dart';
import 'contract_detail_bottom_sheet.dart';

class ContractDetailsDialog {
  static void show(BuildContext context, Contract contract) {
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
}
