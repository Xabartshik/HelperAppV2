import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Провайдер для отслеживания текущей выбранной вкладки
final adminTabProvider = StateProvider<int>((ref) => 0);

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  // Фирменные цвета проекта
  static const Color _primaryColor = Color(0xFF7C3AED);
  static const Color _bgGray900 = Color(0xFF2C2C2E);
  static const Color _bgGray950 = Color(0xFF1C1C1E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(adminTabProvider);
    
    // Определяем ширину экрана для адаптивности
    final isDesktop = MediaQuery.of(context).size.width > 800;

    final destinations = [
      const NavigationRailDestination(icon: Icon(Icons.business), label: Text('Филиалы')),
      const NavigationRailDestination(icon: Icon(Icons.inventory_2_outlined), label: Text('Товары')),
      const NavigationRailDestination(icon: Icon(Icons.people_outline), label: Text('Персонал')),
    ];

    return Scaffold(
      backgroundColor: _bgGray950,
      appBar: AppBar(
        backgroundColor: _bgGray900,
        elevation: 0,
        title: _buildSearchBar(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8, bottom: 8),
            child: ElevatedButton.icon(
              onPressed: () => _openAddForm(context, currentTab),
              icon: const Icon(Icons.add),
              label: const Text('Добавить', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          )
        ],
      ),
      // Drawer показывается только на мобилках
      drawer: isDesktop ? null : Drawer(
        backgroundColor: _bgGray900,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: _bgGray950),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.admin_panel_settings, color: _primaryColor, size: 40),
                  SizedBox(height: 12),
                  Text('Админ-панель', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ...destinations.asMap().entries.map((e) => ListTile(
              leading: e.value.icon,
              title: e.value.label,
              selected: currentTab == e.key,
              selectedTileColor: _primaryColor.withValues(alpha: 0.1),
              selectedColor: _primaryColor,
              iconColor: Colors.white54,
              textColor: Colors.white70,
              onTap: () {
                ref.read(adminTabProvider.notifier).state = e.key;
                Navigator.pop(context); // Закрываем Drawer после выбора
              },
            )),
          ],
        ),
      ),
      body: Row(
        children: [
          // NavigationRail показывается только на широких экранах
          if (isDesktop) ...[
            NavigationRail(
              backgroundColor: _bgGray900,
              selectedIndex: currentTab,
              onDestinationSelected: (idx) => ref.read(adminTabProvider.notifier).state = idx,
              destinations: destinations,
              selectedIconTheme: const IconThemeData(color: _primaryColor),
              unselectedIconTheme: const IconThemeData(color: Colors.white54),
              selectedLabelTextStyle: const TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
              unselectedLabelTextStyle: const TextStyle(color: Colors.white54),
              labelType: NavigationRailLabelType.all,
            ),
            const VerticalDivider(thickness: 1, width: 1, color: Colors.white10),
          ],
          
          // Основная рабочая область
          Expanded(
            child: _buildContent(currentTab),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Поиск...',
          hintStyle: TextStyle(color: Colors.white38),
          prefixIcon: Icon(Icons.search, color: Colors.white54, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }

  Widget _buildContent(int tabIndex) {
    // В будущем здесь будут полноценные списки и таблицы
    switch (tabIndex) {
      case 0: return const Center(child: Text('Вкладка: Филиалы (В разработке)', style: TextStyle(color: Colors.white54)));
      case 1: return const Center(child: Text('Вкладка: Товары (В разработке)', style: TextStyle(color: Colors.white54)));
      case 2: return const Center(child: Text('Вкладка: Персонал (В разработке)', style: TextStyle(color: Colors.white54)));
      default: return const SizedBox();
    }
  }

  void _openAddForm(BuildContext context, int tabIndex) {
    // В будущем здесь будет открываться выезжающая боковая панель (Side Sheet)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Открытие формы добавления для вкладки $tabIndex'),
        backgroundColor: _primaryColor,
      ),
    );
  }
}