import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/models/boss_panel/boss_panel_models.dart';
import '../../core/utils/logger.dart';

// Вспомогательные классы для UI
class SelectableItem<T> {
  final T item;
  bool isSelected;

  SelectableItem({required this.item, this.isSelected = false});
}

class SelectableTreeNode {
  final String title;
  final String nodeValue;
  final int level;
  bool isSelected = false;
  bool isExpanded = false;
  bool isVisible = true;
  List<SelectableTreeNode> children = [];
  
  SelectableTreeNode({
    required this.title,
    required this.nodeValue,
    required this.level,
  });
  
  bool get hasChildren => children.isNotEmpty;
  bool get isLeaf => children.isEmpty;
}

class BossPanelState {
  final bool isLoading;
  final String errorMessage;
  final bool isCreateFormExpanded;
  
  final List<BossPanelTaskCardDto> activeTasks;
  final List<EmployeeWorkloadDto> employeeWorkloads;
  final List<AvailableEmployeeDto> availableEmployees;
  
  final List<SelectableTreeNode> positionTree;
  final List<SelectableTreeNode> flatPositionTree;
  
  final List<SelectableItem<AvailableEmployeeDto>> selectableEmployees;
  
  final String positionSearchText;
  
  final int newInventoryWorkerCount;
  final String newInventoryDescription;
  final int newInventoryPriority;
  final int autoSelectWorkerCount;
  
  final List<AvailableOrderDto> availableOrders;
  final AvailableOrderDto? selectedOrder;
  final String selectedTaskType; // 'Inventory' or 'OrderAssembly'

  const BossPanelState({
    this.isLoading = false,
    this.errorMessage = '',
    this.isCreateFormExpanded = false,
    this.activeTasks = const [],
    this.employeeWorkloads = const [],
    this.availableEmployees = const [],
    this.positionTree = const [],
    this.flatPositionTree = const [],
    this.selectableEmployees = const [],
    this.positionSearchText = '',
    this.newInventoryWorkerCount = 1,
    this.newInventoryDescription = '',
    this.newInventoryPriority = 5,
    this.autoSelectWorkerCount = 1,
    this.availableOrders = const [],
    this.selectedOrder,
    this.selectedTaskType = 'Inventory',
  });

  BossPanelState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isCreateFormExpanded,
    List<BossPanelTaskCardDto>? activeTasks,
    List<EmployeeWorkloadDto>? employeeWorkloads,
    List<AvailableEmployeeDto>? availableEmployees,
    List<SelectableTreeNode>? positionTree,
    List<SelectableTreeNode>? flatPositionTree,
    List<SelectableItem<AvailableEmployeeDto>>? selectableEmployees,
    String? positionSearchText,
    int? newInventoryWorkerCount,
    String? newInventoryDescription,
    int? newInventoryPriority,
    int? autoSelectWorkerCount,
    List<AvailableOrderDto>? availableOrders,
    AvailableOrderDto? selectedOrder,
    String? selectedTaskType,
  }) {
    return BossPanelState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isCreateFormExpanded: isCreateFormExpanded ?? this.isCreateFormExpanded,
      activeTasks: activeTasks ?? this.activeTasks,
      employeeWorkloads: employeeWorkloads ?? this.employeeWorkloads,
      availableEmployees: availableEmployees ?? this.availableEmployees,
      positionTree: positionTree ?? this.positionTree,
      flatPositionTree: flatPositionTree ?? this.flatPositionTree,
      selectableEmployees: selectableEmployees ?? this.selectableEmployees,
      positionSearchText: positionSearchText ?? this.positionSearchText,
      newInventoryWorkerCount: newInventoryWorkerCount ?? this.newInventoryWorkerCount,
      newInventoryDescription: newInventoryDescription ?? this.newInventoryDescription,
      newInventoryPriority: newInventoryPriority ?? this.newInventoryPriority,
      autoSelectWorkerCount: autoSelectWorkerCount ?? this.autoSelectWorkerCount,
      availableOrders: availableOrders ?? this.availableOrders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      selectedTaskType: selectedTaskType ?? this.selectedTaskType,
    );
  }
}

final bossPanelViewModelProvider = AutoDisposeNotifierProvider<BossPanelViewModel, BossPanelState>(() {
  return BossPanelViewModel();
});

class BossPanelViewModel extends AutoDisposeNotifier<BossPanelState> {
  List<PositionCellDto> _allPositions = [];

  @override
  BossPanelState build() {
    Future.microtask(() => loadDataAsync());
    return const BossPanelState();
  }

  void _triggerRebuild() {
    state = state.copyWith(); // Форсируем обновление UI при мутациях
  }

  void toggleCreateForm() {
    state = state.copyWith(isCreateFormExpanded: !state.isCreateFormExpanded);
  }

  void updateSearchText(String text) {
    state = state.copyWith(positionSearchText: text);
    _filterPositionTree(text);
  }

  void updateParameters({
    int? workerCount,
    String? description,
    int? priority,
    int? autoWorkerCount,
    String? selectedTaskType,
    AvailableOrderDto? selectedOrder,
  }) {
    state = state.copyWith(
      newInventoryWorkerCount: workerCount ?? state.newInventoryWorkerCount,
      newInventoryDescription: description ?? state.newInventoryDescription,
      newInventoryPriority: priority ?? state.newInventoryPriority,
      autoSelectWorkerCount: autoWorkerCount ?? state.autoSelectWorkerCount,
      selectedTaskType: selectedTaskType ?? state.selectedTaskType,
      selectedOrder: selectedOrder ?? state.selectedOrder,
    );
  }

  Future<void> loadDataAsync() async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      await Future.wait([
        _loadActiveTasksAsync(),
        _loadEmployeeWorkloadAsync(),
        _loadAvailableEmployeesAsync(),
        _loadAvailablePositionsAsync(),
        _loadAvailableOrdersAsync(),
      ]);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Ошибка загрузки данных: $e');
      Logger.e('BossPanel loadDataAsync error', e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _loadActiveTasksAsync() async {
    final client = ref.read(apiClientProvider);
    final tasks = await client.getBossPanelActiveTasksAsync();
    state = state.copyWith(activeTasks: tasks);
  }

  Future<void> _loadEmployeeWorkloadAsync() async {
    final client = ref.read(apiClientProvider);
    final workloads = await client.getBossPanelEmployeeWorkloadAsync();
    workloads.sort((a, b) => b.activeTasksCount.compareTo(a.activeTasksCount));
    state = state.copyWith(employeeWorkloads: workloads);
  }

  Future<void> _loadAvailableEmployeesAsync() async {
    final client = ref.read(apiClientProvider);
    final available = await client.getBossPanelAvailableEmployeesAsync();
    
    // Сортировка по IsRecommended и ActiveTasksCount
    available.sort((a, b) {
      if (a.isRecommended && !b.isRecommended) return -1;
      if (!a.isRecommended && b.isRecommended) return 1;
      return a.activeTasksCount.compareTo(b.activeTasksCount);
    });

    final selectable = available.map((e) => SelectableItem(item: e)).toList();
    
    state = state.copyWith(
      availableEmployees: available,
      selectableEmployees: selectable,
    );
  }

  Future<void> _loadAvailablePositionsAsync() async {
    final client = ref.read(apiClientProvider);
    _allPositions = await client.getBossPanelPositionsAsync();
    _buildPositionTree();
  }

  Future<void> _loadAvailableOrdersAsync() async {
    final client = ref.read(apiClientProvider);
    final orders = await client.getBossPanelAvailableOrdersAsync();
    state = state.copyWith(availableOrders: orders);
  }

  void _buildPositionTree() {
    final tree = <SelectableTreeNode>[];
    
    if (_allPositions.isEmpty) {
      state = state.copyWith(positionTree: tree);
      _refreshFlatTree();
      return;
    }

    // Группировка Зоны
    final zoneGroups = <String, List<PositionCellDto>>{};
    for (var p in _allPositions) {
      zoneGroups.putIfAbsent(p.zoneCode, () => []).add(p);
    }
    
    final sortedZoneKeys = zoneGroups.keys.toList()..sort();

    for (var zoneKey in sortedZoneKeys) {
      final zoneGroup = zoneGroups[zoneKey]!;
      final branchId = zoneGroup.first.branchId;
      final zonePrefix = '$branchId-$zoneKey';
      final zoneNode = SelectableTreeNode(title: 'Зона: $zoneKey', nodeValue: zonePrefix, level: 0);

      // FLS Group
      final flsGroups = <String, List<PositionCellDto>>{};
      for (var p in zoneGroup) {
        final key = '${p.firstLevelStorageType}_${p.flsNumber}';
        flsGroups.putIfAbsent(key, () => []).add(p);
      }
      
      final sortedFlsKeys = flsGroups.keys.toList()..sort((a, b) {
        final aNum = flsGroups[a]!.first.flsNumber;
        final bNum = flsGroups[b]!.first.flsNumber;
        return aNum.compareTo(bNum);
      });

      for (var flsKey in sortedFlsKeys) {
        final flsGroup = flsGroups[flsKey]!;
        final p = flsGroup.first;
        final flsType = p.firstLevelStorageType;
        final flsNumber = p.flsNumber;
        
        final flsPrefix = '$zonePrefix-$flsType-$flsNumber';
        final flsTitle = '$flsNumber  ·  $flsType';
        final flsNode = SelectableTreeNode(title: flsTitle, nodeValue: flsPrefix, level: 1);

        // SLS Group
        final slsGroups = <String, List<PositionCellDto>>{};
        for (var p in flsGroup) {
          if (p.secondLevelStorage != null && p.secondLevelStorage!.isNotEmpty) {
            slsGroups.putIfAbsent(p.secondLevelStorage!, () => []).add(p);
          }
        }
        
        final sortedSlsKeys = slsGroups.keys.toList()..sort();
        
        for (var slsKey in sortedSlsKeys) {
          final sndGroup = slsGroups[slsKey]!;
          final sndPrefix = '$flsPrefix-$slsKey';
          final sndNode = SelectableTreeNode(title: 'Полка $slsKey', nodeValue: sndPrefix, level: 2);
          
          // TLS Group
          final tlsGroups = <String, List<PositionCellDto>>{};
          for (var p in sndGroup) {
            if (p.thirdLevelStorage != null && p.thirdLevelStorage!.isNotEmpty) {
              tlsGroups.putIfAbsent(p.thirdLevelStorage!, () => []).add(p);
            }
          }
          
          final sortedTlsKeys = tlsGroups.keys.toList()..sort();
          for (var tlsKey in sortedTlsKeys) {
            final trdPrefix = '$sndPrefix-$tlsKey';
            final trdNode = SelectableTreeNode(title: 'Ячейка $tlsKey', nodeValue: trdPrefix, level: 3);
            sndNode.children.add(trdNode);
          }
          
          flsNode.children.add(sndNode);
        }
        
        zoneNode.children.add(flsNode);
      }
      
      tree.add(zoneNode);
    }
    
    state = state.copyWith(positionTree: tree);
    _refreshFlatTree();
  }

  void _refreshFlatTree() {
    final flatList = <SelectableTreeNode>[];
    for (var root in state.positionTree) {
      _flattenNode(root, flatList, true);
    }
    state = state.copyWith(flatPositionTree: flatList);
  }

  void _flattenNode(SelectableTreeNode node, List<SelectableTreeNode> list, bool parentVisible) {
    if (!parentVisible || !node.isVisible) return;
    list.add(node);
    
    if (node.hasChildren && node.isExpanded) {
      for (var child in node.children) {
        _flattenNode(child, list, true);
      }
    }
  }

  void toggleNodeExpanded(SelectableTreeNode node) {
    node.isExpanded = !node.isExpanded;
    _refreshFlatTree();
  }

  void toggleNodeSelected(SelectableTreeNode node, bool isSelected) {
    // Устанавливаем выбор для самого узла и всех его потомков
    _setNodeSelectedRecursive(node, isSelected);
    // Обновляем состояние родительских узлов (частичный/полный выбор)
    for (var root in state.positionTree) {
      _updateParentSelectionState(root);
    }
    _triggerRebuild();
  }

  /// Рекурсивно выбирает/снимает выбор со всех дочерних узлов
  void _setNodeSelectedRecursive(SelectableTreeNode node, bool isSelected) {
    node.isSelected = isSelected;
    for (var child in node.children) {
      _setNodeSelectedRecursive(child, isSelected);
    }
  }

  /// Возвращает true, если все листья в поддереве выбраны
  /// Обновляет isSelected родителей согласно состоянию детей
  bool _updateParentSelectionState(SelectableTreeNode node) {
    if (node.isLeaf) return node.isSelected;
    
    bool allChildrenSelected = true;
    for (var child in node.children) {
      if (!_updateParentSelectionState(child)) {
        allChildrenSelected = false;
      }
    }
    // Родитель считается выбранным, только если все его потомки выбраны
    node.isSelected = allChildrenSelected;
    return allChildrenSelected;
  }

  void toggleEmployeeSelected(SelectableItem<AvailableEmployeeDto> emp, bool isSelected) {
    emp.isSelected = isSelected;
    _triggerRebuild();
  }

  void _filterPositionTree(String searchText) {
    final search = searchText.trim().toLowerCase();
    final isSearching = search.isNotEmpty;
    
    for (var node in state.positionTree) {
      _filterNodeRecursive(node, search, isSearching);
    }
    _refreshFlatTree();
  }

  bool _filterNodeRecursive(SelectableTreeNode node, String search, bool isSearching) {
    bool selfMatch = search.isEmpty || node.title.toLowerCase().contains(search);
    bool anyChildVisible = false;
    
    for (var child in node.children) {
      bool childVisible = _filterNodeRecursive(child, search, isSearching);
      if (childVisible) anyChildVisible = true;
    }
    
    bool isVisible = selfMatch || anyChildVisible;
    node.isVisible = isVisible;
    
    if (isSearching && isVisible) {
      node.isExpanded = true;
    } else if (!isSearching) {
      node.isExpanded = false;
    }
    
    return isVisible;
  }

  Future<void> autoSelectEmployeesAsync() async {
    if (state.autoSelectWorkerCount < 1) {
      state = state.copyWith(errorMessage: 'Количество для подбора должно быть больше 0');
      return;
    }
    
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final client = ref.read(apiClientProvider);
      final selectedIds = await client.getBossPanelAutoSelectedEmployeesAsync(state.autoSelectWorkerCount);
      
      for (var emp in state.selectableEmployees) {
        emp.isSelected = false;
      }
      
      int matchedCount = 0;
      for (var id in selectedIds) {
        final emp = state.selectableEmployees.where((e) => e.item.employeeId == id).firstOrNull;
        if (emp != null) {
          emp.isSelected = true;
          matchedCount++;
        }
      }
      
      if (matchedCount == 0) {
        state = state.copyWith(errorMessage: 'Не удалось подобрать сотрудников. Возможно, их нет на смене.');
      } else {
        _triggerRebuild(); // обновляем UI чекбоксов
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Ошибка автоподбора: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> createInventoryAsync() async {
    if (state.newInventoryWorkerCount < 1) {
      state = state.copyWith(errorMessage: 'Количество работников должно быть больше 0');
      return false;
    }
    
    final selectedPrefixes = <String>[];
    
    void collectSelectedLeaves(SelectableTreeNode node) {
      if (node.isLeaf && node.isSelected) {
        selectedPrefixes.add(node.nodeValue);
      }
      for (var child in node.children) {
        collectSelectedLeaves(child);
      }
    }
    
    for (var root in state.positionTree) {
      collectSelectedLeaves(root);
    }
    
    final selectedEmployees = state.selectableEmployees
        .where((e) => e.isSelected)
        .map((e) => e.item.employeeId)
        .toList();
        
    state = state.copyWith(isLoading: true, errorMessage: '');
    
    try {
      final client = ref.read(apiClientProvider);
      
      final dto = CreateInventoryByZoneDto(
        priority: state.newInventoryPriority,
        workerCount: state.newInventoryWorkerCount,
        description: state.newInventoryDescription.trim().isEmpty ? 'Инвентаризация' : state.newInventoryDescription.trim(),
        zonePrefixes: selectedPrefixes,
        workerIds: selectedEmployees.isNotEmpty ? selectedEmployees : null,
      );
      
      final result = await client.createBossPanelInventoryTaskByZoneAsync(dto);
      
      if (result != null) {
        await loadDataAsync();
        
        state = state.copyWith(
          newInventoryDescription: '',
          newInventoryWorkerCount: 1,
          newInventoryPriority: 5,
          autoSelectWorkerCount: 1,
          positionSearchText: '',
          isCreateFormExpanded: false,
        );
        for (var e in state.selectableEmployees) { e.isSelected = false; }
        _buildPositionTree();
        
        return true; // Успешно
      }
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Ошибка создания задачи: $e', isLoading: false);
      return false;
    }
  }

  Future<bool> createOrderAssemblyTaskAsync() async {
    if (state.selectedOrder == null) {
      state = state.copyWith(errorMessage: 'Выберите заказ для сборки');
      return false;
    }

    final selectedEmployees = state.selectableEmployees
        .where((e) => e.isSelected)
        .map((e) => e.item.employeeId)
        .toList();

    if (selectedEmployees.isEmpty) {
      state = state.copyWith(errorMessage: 'Выберите сотрудника для назначения задачи');
      return false;
    }

    if (selectedEmployees.length > 1) {
      state = state.copyWith(errorMessage: 'Для сборки заказа можно выбрать только одного сотрудника');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final client = ref.read(apiClientProvider);
      
      final dto = CreateOrderAssemblyTaskDto(
        orderId: state.selectedOrder!.orderId,
        assignedUserId: selectedEmployees.first,
        priority: state.newInventoryPriority,
        description: state.newInventoryDescription.trim().isEmpty ? null : state.newInventoryDescription.trim(),
      );
      
      final taskId = await client.createBossPanelOrderAssemblyTaskAsync(dto);
      
      if (taskId > 0) {
        await loadDataAsync();
        
        state = state.copyWith(
          newInventoryDescription: '',
          newInventoryPriority: 7, // дефолт для сборки
          isCreateFormExpanded: false,
          selectedOrder: null,
        );
        for (var e in state.selectableEmployees) { e.isSelected = false; }
        
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Ошибка создания задачи сборки: $e', isLoading: false);
      return false;
    }
  }
}
