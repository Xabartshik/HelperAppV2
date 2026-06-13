import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/models/user/mobile_app_user_dto.dart';

// Состояние для экрана управления пользователями мобильного приложения
class AdminMobileUsersState {
  final bool isLoading;
  final List<MobileAppUserDto> users;
  final String searchQuery;

  AdminMobileUsersState({this.isLoading = false, this.users = const [], this.searchQuery = ''});

  AdminMobileUsersState copyWith({bool? isLoading, List<MobileAppUserDto>? users, String? searchQuery}) {
    return AdminMobileUsersState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<MobileAppUserDto> get filteredUsers {
    if (searchQuery.isEmpty) return users;
    final q = searchQuery.toLowerCase();
    return users.where((u) => 
      (u.firstName?.toLowerCase().contains(q) ?? false) || 
      (u.lastName?.toLowerCase().contains(q) ?? false) ||
      u.login.toLowerCase().contains(q)
    ).toList();
  }
}

final adminMobileUsersProvider = AutoDisposeNotifierProvider<AdminMobileUsersViewModel, AdminMobileUsersState>(
  () => AdminMobileUsersViewModel(),
);

class AdminMobileUsersViewModel extends AutoDisposeNotifier<AdminMobileUsersState> {
  @override
  AdminMobileUsersState build() {
    Future.microtask(() => loadUsers());
    return AdminMobileUsersState();
  }

  // Получение всех пользователей
  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true);
    final list = await ref.read(apiClientProvider).getMobileAppUsersAsync();
    state = state.copyWith(users: list, isLoading: false);
  }

  // Поиск по пользователям
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  // Переключение активности пользователя
  Future<void> toggleActiveStatus(MobileAppUserDto user) async {
    state = state.copyWith(isLoading: true);
    final success = await ref.read(apiClientProvider).updateMobileUserActiveAsync(user.id, !user.isActive);
    if (success) {
      await loadUsers();
    }
    state = state.copyWith(isLoading: false);
  }
}
