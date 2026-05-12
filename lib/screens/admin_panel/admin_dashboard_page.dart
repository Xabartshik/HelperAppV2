import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/screens/admin_panel/tabs/employees/admin_employees_tab.dart';
import 'package:helper_app/screens/admin_panel/tabs/employees/admin_employees_viewmodel.dart';
import 'package:helper_app/screens/admin_panel/tabs/items/admin_items_tab.dart';
import 'package:helper_app/screens/admin_panel/tabs/items/admin_items_viewmodel.dart';
import 'package:helper_app/screens/admin_panel/tabs/positions/admin_positions_tab.dart';
import 'package:helper_app/screens/admin_panel/tabs/positions/admin_positions_viewmodel.dart';
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
      const NavigationRailDestination(icon: Icon(Icons.inventory_2), label: Text('Товары')),
      const NavigationRailDestination(icon: Icon(Icons.people), label: Text('Персонал')),
      const NavigationRailDestination(icon: Icon(Icons.grid_view), label: Text('Позиции')),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bgGray950,
      endDrawer: _buildEndDrawer(currentTab),
      appBar: AppBar(
        backgroundColor: _bgGray900,
        elevation: 0,
        title: _buildSearchBar(currentTab, ref),
        actions: [
          // Неработающая кнопка "Добавить" удалена, так как у каждой вкладки есть свой FAB (Floating Action Button)
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white54),
            onPressed: () => ref.read(authServiceProvider).logoutAsync(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              selectedIndex: currentTab,
              onDestinationSelected: (index) => ref.read(adminTabProvider.notifier).state = index,
              backgroundColor: _bgGray900,
              indicatorColor: _primaryColor.withOpacity(0.2),
              selectedIconTheme: const IconThemeData(color: _primaryColor),
              unselectedIconTheme: const IconThemeData(color: Colors.white54),
              labelType: NavigationRailLabelType.all,
              destinations: destinations,
            ),
          Expanded(
            child: Container(
              color: _bgGray950,
              child: _buildContent(currentTab),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              currentIndex: currentTab,
              onTap: (index) => ref.read(adminTabProvider.notifier).state = index,
              backgroundColor: _bgGray900,
              selectedItemColor: _primaryColor,
              unselectedItemColor: Colors.white54,
              type: BottomNavigationBarType.fixed,
              items: destinations
                  .map((d) => BottomNavigationBarItem(icon: d.icon, label: (d.label as Text).data))
                  .toList(),
            ),
    );
  }

  Widget _buildSearchBar(int currentTab, WidgetRef ref) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: (value) {
          if (currentTab == 0) ref.read(adminBranchesProvider.notifier).setSearchQuery(value);
          if (currentTab == 1) ref.read(adminItemsProvider.notifier).setSearchQuery(value);
          if (currentTab == 2) ref.read(adminEmployeesProvider.notifier).setSearchQuery(value);
          if (currentTab == 3) ref.read(adminPositionsProvider.notifier).setSearchQuery(value);
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
      case 1: return const AdminItemsTab();
      case 2: return const AdminEmployeesTab();
      case 3: return const AdminPositionsTab();
      default: return const SizedBox();
    }
  }

  Widget? _buildEndDrawer(int tabIndex) {
    switch (tabIndex) {
      case 0: return const Drawer(width: 400, backgroundColor: _bgGray900, child: BranchFormPanel());
      case 1: return const Drawer(width: 400, backgroundColor: _bgGray900, child: ItemFormPanel());
      case 2: return const Drawer(width: 400, backgroundColor: _bgGray900, child: EmployeeFormPanel());
      case 3: return const Drawer(width: 400, backgroundColor: _bgGray900, child: PositionFormPanel());
      default: return null;
    }
  }
}