import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/auth_service.dart';
import 'tabs/branches/admin_branches_tab.dart';
import 'tabs/branches/admin_branches_viewmodel.dart';

final adminTabProvider = StateProvider<int>((ref) => 0);

class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  // Ключ для управления Scaffold (решает проблему с открытием боковой панели)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color _primaryColor = Color(0xFF7C3AED);
  static const Color _bgGray900 = Color(0xFF2C2C2E);
  static const Color _bgGray950 = Color(0xFF1C1C1E);

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(adminTabProvider);
    final isDesktop = MediaQuery.of(context).size.width > 800;

    final destinations = [
      const NavigationRailDestination(icon: Icon(Icons.business), label: Text('Филиалы')),
      const NavigationRailDestination(icon: Icon(Icons.inventory_2_outlined), label: Text('Товары')),
      const NavigationRailDestination(icon: Icon(Icons.people_outline), label: Text('Персонал')),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bgGray950,
      appBar: AppBar(
        backgroundColor: _bgGray900,
        elevation: 0,
        title: _buildSearchBar(currentTab),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: ElevatedButton.icon(
              onPressed: () => _openAddForm(currentTab),
              icon: const Icon(Icons.add),
              label: const Text('Добавить', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            tooltip: 'Выйти',
            onPressed: () => ref.read(authServiceProvider).logoutAsync(),
          ),
          const SizedBox(width: 16),
        ],
      ),
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
              selectedTileColor: _primaryColor.withOpacity(0.1),
              selectedColor: _primaryColor,
              iconColor: Colors.white54,
              textColor: Colors.white70,
              onTap: () {
                ref.read(adminTabProvider.notifier).state = e.key;
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
      
      // Динамическая боковая панель для форм
      endDrawer: _buildEndDrawer(currentTab),
      
      body: Row(
        children: [
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
          Expanded(child: _buildContent(currentTab)),
        ],
      ),
    );
  }

  // Метод для выбора нужной формы в зависимости от текущей вкладки
  Widget? _buildEndDrawer(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const Drawer(
          width: 400,
          backgroundColor: _bgGray900,
          child: BranchFormPanel(), // Универсальная форма для филиалов
        );
      case 1:
        // В будущем здесь будет форма для товаров
        return null;
      case 2:
        // В будущем здесь будет форма для персонала
        return null;
      default:
        return null;
    }
  }

  // Обновленный поиск, реагирующий на ввод текста
  Widget _buildSearchBar(int currentTab) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        onChanged: (value) {
          // Направляем текст поиска в нужную вкладку
          if (currentTab == 0) {
            ref.read(adminBranchesProvider.notifier).setSearchQuery(value);
          }
        },
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: const InputDecoration(
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
    switch (tabIndex) {
      case 0: return const AdminBranchesTab();
      case 1: return const Center(child: Text('Вкладка: Товары (В разработке)', style: TextStyle(color: Colors.white54)));
      case 2: return const Center(child: Text('Вкладка: Персонал (В разработке)', style: TextStyle(color: Colors.white54)));
      default: return const SizedBox();
    }
  }

  // Безопасное открытие боковой панели через GlobalKey
  void _openAddForm(int tabIndex) {
    if (tabIndex == 0) {
      // Сбрасываем выбранный филиал, чтобы форма была пустой для создания
      ref.read(editingBranchProvider.notifier).state = null;
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Для этой вкладки форма еще не готова')),
      );
    }
  }
}