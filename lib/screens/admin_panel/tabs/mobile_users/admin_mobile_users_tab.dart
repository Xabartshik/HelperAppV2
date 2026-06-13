import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/user/mobile_app_user_dto.dart';
import 'admin_mobile_users_viewmodel.dart';

// Перевод ролей для отображения пользователю
String translateMobileRole(MobileUserRole role) {
  switch (role) {
    case MobileUserRole.worker: return "Работник";
    case MobileUserRole.supervisor: return "Начальник";
    case MobileUserRole.admin: return "Администратор";
    case MobileUserRole.customer: return "Покупатель";
    case MobileUserRole.courier: return "Курьер";
    default: return "Неизвестно";
  }
}

class AdminMobileUsersTab extends ConsumerWidget {
  const AdminMobileUsersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminMobileUsersProvider);
    
    if (state.isLoading && state.users.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)));
    }

    if (state.filteredUsers.isEmpty) {
      return const Center(child: Text("Пользователи не найдены", style: TextStyle(color: Colors.white54)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.filteredUsers.length,
      itemBuilder: (context, index) {
        final user = state.filteredUsers[index];
        final isBlocked = !user.isActive;
        
        return Card(
          color: const Color(0xFF1C1C1E),
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isBlocked ? Colors.redAccent.withValues(alpha: 0.2) : const Color(0xFF7C3AED).withValues(alpha: 0.2),
              child: Icon(
                user.role == MobileUserRole.customer ? Icons.shopping_bag : Icons.person,
                color: isBlocked ? Colors.redAccent : const Color(0xFF7C3AED),
                size: 18,
              ),
            ),
            title: Text(user.fullName.isEmpty ? "Без имени" : user.fullName, 
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.bold,
                decoration: isBlocked ? TextDecoration.lineThrough : null,
              )),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Логин: ${user.login} • ${translateMobileRole(user.role)}", 
                  style: const TextStyle(color: Colors.white54, fontSize: 12)),
                if (isBlocked)
                  const Text("Заблокирован", style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                isBlocked ? Icons.lock : Icons.lock_open,
                color: isBlocked ? Colors.redAccent : Colors.greenAccent,
              ),
              onPressed: () => _showToggleDialog(context, ref, user),
              tooltip: isBlocked ? 'Разблокировать пользователя' : 'Заблокировать пользователя',
            ),
          ),
        );
      },
    );
  }

  // Подтверждающий диалог блокировки пользователя
  void _showToggleDialog(BuildContext context, WidgetRef ref, MobileAppUserDto user) {
    final willBlock = user.isActive;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: Text(willBlock ? 'Блокировка пользователя' : 'Разблокировка пользователя', style: const TextStyle(color: Colors.white)),
        content: Text(
          willBlock
              ? 'Вы уверены, что хотите заблокировать пользователя ${user.firstName} ${user.lastName}?'
              : 'Вы уверены, что хотите разблокировать пользователя ${user.firstName} ${user.lastName}?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена', style: TextStyle(color: Colors.white38)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(adminMobileUsersProvider.notifier).toggleActiveStatus(user);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: willBlock ? Colors.redAccent : Colors.greenAccent,
            ),
            child: Text(willBlock ? 'Заблокировать' : 'Разблокировать', style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
