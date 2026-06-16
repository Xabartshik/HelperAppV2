import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/network/api_endpoints.dart';
import 'reports_tab_viewmodel.dart';

class ReportsTab extends ConsumerWidget {
  const ReportsTab({super.key});

  static const Color _primaryColor = Color(0xFF7C3AED);
  static const Color _bgGray900 = Color(0xFF2C2C2E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportsTabViewModelProvider);
    final vm = ref.read(reportsTabViewModelProvider.notifier);

    // Слушаем ошибки и успех для показа Snackbar
    ref.listen<ReportsTabState>(reportsTabViewModelProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: Colors.red),
        );
        vm.clearMessages();
      }
      if (next.successMessage != null && next.successMessage != previous?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!), backgroundColor: Colors.green),
        );
        vm.clearMessages();
      }
    });

    final dateFormat = DateFormat('dd.MM.yyyy');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Блок выбора дат
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _bgGray900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Период отчета', style: TextStyle(color: Colors.white54, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${dateFormat.format(state.startDate)} - ${dateFormat.format(state.endDate)}',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: state.isDownloading ? null : () => _selectDateRange(context, vm, state),
                      icon: const Icon(Icons.date_range, size: 18),
                      label: const Text('Изменить'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          const Text('Доступные выгрузки', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          if (state.isDownloading)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: CircularProgressIndicator(color: _primaryColor)),
            )
          else ...[
            // Карточки отчетов
            _ReportCard(
              title: 'Дашборд заказов',
              subtitle: 'Статистика, ТОП-товары и выручка',
              icon: Icons.dashboard_outlined,
              color: Colors.blue,
              onTap: () => vm.downloadReport(ApiEndpoints.exportDashboardPdf, 'Dashboard', 'pdf'),
            ),
            _ReportCard(
              title: 'Статистика персонала',
              subtitle: 'Детальные графики загруженности и таймингов',
              icon: Icons.people_alt_outlined,
              color: Colors.orange,
              onTap: () => vm.downloadReport(ApiEndpoints.exportEmployeeFullPdf, 'Employees_Deep', 'pdf'),
            ),
            _ReportCard(
              title: 'Сырые данные (CSV)',
              subtitle: 'Lead time заказов для Excel',
              icon: Icons.table_chart_outlined,
              color: Colors.green,
              onTap: () => vm.downloadReport(ApiEndpoints.exportOrderLeadTimeCsv, 'LeadTime_Data', 'csv'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context, ReportsTabViewModel vm, ReportsTabState state) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: state.startDate, end: state.endDate),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _primaryColor,
              onPrimary: Colors.white,
              surface: _bgGray900,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      vm.setDateRange(picked.start, picked.end);
    }
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ReportCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2C2C2E),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.2), shape: BoxShape.circle),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        trailing: const Icon(Icons.download_rounded, color: Colors.white54),
        onTap: onTap,
      ),
    );
  }
}