import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:helper_app/core/services/auth_service.dart';
import 'package:helper_app/screens/widgets/recent_orders_widget.dart';
import 'customer_home_viewmodel.dart';
// Предполагается, что эти импорты добавлены в проект
// import 'auth_provider.dart'; 
// import 'recent_orders_widget.dart';

class CustomerHomePage extends ConsumerWidget {
  const CustomerHomePage({super.key});

  final _backgroundColor = const Color(0xFF141414);
  final _cardColor = const Color(0xFF1C1C1E);
  final _primaryColor = const Color(0xFF7C3AED);
  final _secondaryTextColor = const Color(0xFFA1A1AA);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(customerHomeViewModelProvider.notifier);
    final state = ref.watch(customerHomeViewModelProvider);
    // 1. Получаем текущего пользователя для передачи ID в виджет заказов
    final currentUser = ref.read(currentUserProvider);

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        title: const Text('TaskControl', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _showLogoutDialog(context, vm),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: vm.refreshData,
        color: _primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Приветствие
              Text(
                'Привет, ${vm.userName}! 👋',
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Ваш персональный кабинет управления заказами',
                style: TextStyle(color: _secondaryTextColor, fontSize: 16),
              ),
              const SizedBox(height: 32),

              // Сетка основных действий
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildActionCard(
                    context,
                    title: 'Создать заказ',
                    icon: Icons.add_shopping_cart_rounded,
                    color: _primaryColor,
                    onTap: () => context.push('/customer/orders/create'),
                  ),
                  _buildActionCard(
                    context,
                    title: 'Мои заказы',
                    icon: Icons.local_shipping_outlined,
                    color: Colors.blueAccent,
                    onTap: () => context.push('/customer/orders/list'),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Информационный баннер
              //_buildInfoBanner(),

              const SizedBox(height: 32),

              // 2. Обновленная нижняя секция с логикой загрузки и списком заказов
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Недавние заказы',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.history, color: Colors.white70),
                ],
              ),
              const SizedBox(height: 16),

              if (state.isLoading)
                const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED))) //
              else if (currentUser != null)
                RecentOrdersWidget(customerId: currentUser.customerId!) // Используем реальный виджет вместо заглушки
              else
                _buildOrderPlaceholder(), //
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor.withOpacity(0.8), _primaryColor.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Статус: VIP Клиент',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Вам доступна бесплатная доставка в постаматы',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderPlaceholder() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined, color: _secondaryTextColor, size: 48),
            const SizedBox(height: 12),
            Text(
              'У вас пока нет активных заказов',
              style: TextStyle(color: _secondaryTextColor),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, CustomerHomeViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor,
        title: const Text('Выход', style: TextStyle(color: Colors.white)),
        content: const Text('Вы уверены, что хотите выйти?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              vm.logout();
            },
            child: const Text('Выйти', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}