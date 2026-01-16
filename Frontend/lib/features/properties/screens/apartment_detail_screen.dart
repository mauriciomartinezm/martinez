import 'package:flutter/material.dart';
import 'package:martinez/core/theme/app_colors.dart';
import '../../../core/models/pago_mensual.dart';
import '../../../core/services/api_service.dart';
import '../../home/logic/home_controller.dart';
import '../../tenants/widgets/payment_card.dart';
import '../../tenants/controllers/tenant_payments_controller.dart';

class ApartmentDetailScreen extends StatefulWidget {
  const ApartmentDetailScreen({super.key, required this.controller});

  final HomeController controller;

  @override
  State<ApartmentDetailScreen> createState() => _ApartmentDetailScreenState();
}

class _ApartmentDetailScreenState extends State<ApartmentDetailScreen> {
  List<PagoMensual> _apartmentPayments = [];
  bool _isLoadingPayments = false;
  late TenantPaymentsController _paymentsController;

  @override
  void initState() {
    super.initState();
    _paymentsController = TenantPaymentsController();
    _loadPayments();
  }

  @override
  void dispose() {
    _paymentsController.dispose();
    super.dispose();
  }

  Future<void> _loadPayments() async {
    if (widget.controller.selectedApartment == null) return;
    
    setState(() {
      _isLoadingPayments = true;
    });

    try {
      final allPayments = await fetchPagos();
      final apartmentId = widget.controller.selectedApartment!.id;
      debugPrint('Cargando pagos para el apartamento ID: $apartmentId');
      _apartmentPayments = allPayments
          .where((pago) => pago.contratoArriendo.apartamento.id == apartmentId)
          .toList();
      debugPrint('Pagos encontrados: ${_apartmentPayments.length}');
      _apartmentPayments.sort((a, b) {
        final yearCompare = b.anio.compareTo(a.anio);
        if (yearCompare != 0) return yearCompare;
        return _getMonthNumber(b.mes).compareTo(_getMonthNumber(a.mes));
      });
    } catch (e) {
      _apartmentPayments = [];
    }

    if (mounted) {
      setState(() {
        _isLoadingPayments = false;
      });
    }
  }

  int _getMonthNumber(String mes) {
    const months = {
      'enero': 1, 'febrero': 2, 'marzo': 3, 'abril': 4,
      'mayo': 5, 'junio': 6, 'julio': 7, 'agosto': 8,
      'septiembre': 9, 'octubre': 10, 'noviembre': 11, 'diciembre': 12
    };
    return months[mes.toLowerCase()] ?? 0;
  }

  String _getMonthName(int monthNumber) {
    const months = [
      'enero', 'febrero', 'marzo', 'abril',
      'mayo', 'junio', 'julio', 'agosto',
      'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return months[monthNumber - 1];
  }

  List<String> _getUnrentedMonths() {
    if (_apartmentPayments.isEmpty) {
      return ['No hay datos de pagos'];
    }

    // Crear un conjunto de meses con pago
    final paidMonths = <String>{};
    for (final pago in _apartmentPayments) {
      paidMonths.add('${pago.mes.toLowerCase()}-${pago.anio}');
    }

    // Obtener el rango de fechas
    final oldestPayment = _apartmentPayments.last;
    final newestPayment = _apartmentPayments.first;
    
    final startMonth = _getMonthNumber(oldestPayment.mes);
    final startYear = int.parse(oldestPayment.anio);
    final endMonth = _getMonthNumber(newestPayment.mes);
    final endYear = int.parse(newestPayment.anio);

    // Buscar meses sin pago
    final unrentedMonths = <String>[];
    int currentMonth = startMonth;
    int currentYear = startYear;

    while (currentYear < endYear || (currentYear == endYear && currentMonth <= endMonth)) {
      final monthKey = '${_getMonthName(currentMonth)}-$currentYear';
      if (!paidMonths.contains(monthKey)) {
        unrentedMonths.add('${_getMonthName(currentMonth).substring(0, 3)} $currentYear');
      }
      
      currentMonth++;
      if (currentMonth > 12) {
        currentMonth = 1;
        currentYear++;
      }
    }

    return unrentedMonths.isEmpty 
        ? ['No hay meses sin arriendo'] 
        : unrentedMonths;
  }

  @override
  Widget build(BuildContext context) {
    final apartment = widget.controller.selectedApartment;
    if (apartment == null) {
      return const Scaffold(
        body: Center(child: Text('Apartamento no disponible')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Apartamento', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.controller.goBackToApartments();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.apartment, size: 48, color: AppColors.primary),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              apartment.edificio.nombre,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Piso ${apartment.piso}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!_isLoadingPayments && _apartmentPayments.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.event_busy,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Meses sin arriendo',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...(_getUnrentedMonths().map((month) => Padding(
                      padding: const EdgeInsets.only(left: 28, top: 4),
                      child: Text(
                        month,
                        style: TextStyle(
                          fontSize: 13,
                          color: month == 'No hay meses sin arriendo' || month == 'No hay datos de pagos'
                              ? Colors.green[700]
                              : Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            /*
            // Rent date info
            if (apartment.rentDate != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fecha de arrendamiento',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6F6F6F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      apartment.rentDate!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Rent amount info
            if (apartment.rentAmount != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monto del arriendo',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6F6F6F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      apartment.rentAmount!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            */
           
            // Payments section
            if (_isLoadingPayments)
              const Center(child: CircularProgressIndicator())
            else if (_apartmentPayments.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      Text(
                        'No hay pagos registrados',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Historial de pagos (${_apartmentPayments.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _apartmentPayments.length,
                    itemBuilder: (context, index) {
                      final pago = _apartmentPayments[index];
                      return PaymentCard(
                        pago: pago,
                        controller: _paymentsController,
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
