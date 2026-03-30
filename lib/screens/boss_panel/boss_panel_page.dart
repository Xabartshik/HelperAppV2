import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'boss_panel_viewmodel.dart';
import '../../core/models/boss_panel/boss_panel_models.dart';

class BossPanelPage extends ConsumerStatefulWidget {
  const BossPanelPage({super.key});

  @override
  ConsumerState<BossPanelPage> createState() => _BossPanelPageState();
}

class _BossPanelPageState extends ConsumerState<BossPanelPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _descriptionController = TextEditingController();
  final _workerCountController = TextEditingController(text: '1');
  final _priorityController = TextEditingController(text: '5');
  final _autoSelectWorkerController = TextEditingController(text: '1');
  
  // Цвета
  final Color _bgOffBlack = const Color(0xFF141414);
  final Color _bgGray950 = const Color(0xFF1C1C1E);
  final Color _bgGray900 = const Color(0xFF2C2C2E);
  final Color _primaryColor = const Color(0xFF7C3AED);
  final Color _textColor = Colors.white;
  final Color _gray400 = const Color(0xFFA1A1AA);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _descriptionController.dispose();
    _workerCountController.dispose();
    _priorityController.dispose();
    _autoSelectWorkerController.dispose();
    super.dispose();
  }

  void _updateViewModelFields() {
    final vm = ref.read(bossPanelViewModelProvider.notifier);
    vm.updateParameters(
      description: _descriptionController.text,
      workerCount: int.tryParse(_workerCountController.text) ?? 1,
      priority: int.tryParse(_priorityController.text) ?? 5,
      autoWorkerCount: int.tryParse(_autoSelectWorkerController.text) ?? 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bossPanelViewModelProvider);
    final vm = ref.read(bossPanelViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: _bgOffBlack,
      appBar: AppBar(
        title: const Text('Панель руководителя'),
        backgroundColor: _bgGray950,
        foregroundColor: _textColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _primaryColor,
          labelColor: _textColor,
          unselectedLabelColor: _gray400,
          labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: "Активные задачи"),
            Tab(text: "Создать задачу"),
            Tab(text: "Сотрудники"),
          ],
        ),
      ),
      body: state.isLoading && state.activeTasks.isEmpty
          ? Center(child: CircularProgressIndicator(color: _primaryColor))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildActiveTasksTab(state, vm),
                _buildCreateTaskTab(state, vm),
                _buildEmployeesTab(state, vm),
              ],
            ),
    );
  }

  Widget _buildActiveTasksTab(BossPanelState state, BossPanelViewModel vm) {
    return RefreshIndicator(
      onRefresh: () => vm.loadDataAsync(),
      child: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: state.activeTasks.length + 1, // +1 для заголовка
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Text(
                'Текущие активные задачи в филиале',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }
          final task = state.activeTasks[index - 1];
          return _buildTaskCard(task);
        },
      ),
    );
  }

  Widget _buildTaskCard(BossPanelTaskCardDto task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: _bgGray900, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.title, style: TextStyle(color: _textColor, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text('Тип: ${task.taskType}', style: TextStyle(color: _primaryColor, fontSize: 14)),
          Text('От: ${task.createdAt.day.toString().padLeft(2, '0')}.${task.createdAt.month.toString().padLeft(2, '0')}.${task.createdAt.year} ${task.createdAt.hour.toString().padLeft(2, '0')}:${task.createdAt.minute.toString().padLeft(2, '0')}', style: const TextStyle(color: Color(0xFFD1D5DB), fontSize: 12)),
          
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: task.progressValue,
                  color: _primaryColor,
                  backgroundColor: _bgOffBlack,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              Text('${task.overallProgressPercentage}%', style: TextStyle(color: _textColor)),
            ],
          ),

          const SizedBox(height: 10),
          Text('Исполнители:', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          ...task.assignees.map((a) => Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Text('• ', style: TextStyle(color: _primaryColor)),
                Expanded(child: Text(a.fullName, style: TextStyle(color: _textColor))),
                Text(a.status, style: const TextStyle(color: Color(0xFFD1D5DB))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildCreateTaskTab(BossPanelState state, BossPanelViewModel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: _bgGray900, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () => vm.toggleCreateForm(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Создание инвентаризации', style: TextStyle(color: _textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                      Icon(
                        state.isCreateFormExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: _textColor,
                      ),
                    ],
                  ),
                ),
                if (state.isCreateFormExpanded) ...[
                  const SizedBox(height: 15),
                  Text('Описание задачи:', style: TextStyle(color: _textColor)),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _descriptionController,
                    onChanged: (_) => _updateViewModelFields(),
                    style: TextStyle(color: _textColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _bgOffBlack,
                      hintText: 'Введите описание...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Кол-во сотрудников:', style: TextStyle(color: _textColor)),
                            const SizedBox(height: 5),
                            TextField(
                              controller: _workerCountController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => _updateViewModelFields(),
                              style: TextStyle(color: _textColor),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: _bgOffBlack,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Приоритет (1-10):', style: TextStyle(color: _textColor)),
                            const SizedBox(height: 5),
                            TextField(
                              controller: _priorityController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => _updateViewModelFields(),
                              style: TextStyle(color: _textColor),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: _bgOffBlack,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Дерево позиций
                  const SizedBox(height: 15),
                  Text('Выбор зон (оставьте пустым для всех):', style: TextStyle(color: _textColor)),
                  const SizedBox(height: 5),
                  TextField(
                    onChanged: (val) => vm.updateSearchText(val),
                    style: TextStyle(color: _textColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _bgOffBlack,
                      hintText: 'Поиск по зонам/стеллажам...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Container(
                    height: 280,
                    decoration: BoxDecoration(color: _bgGray950, borderRadius: BorderRadius.circular(8)),
                    child: ListView.builder(
                      itemCount: state.flatPositionTree.length,
                      itemBuilder: (context, index) {
                        final node = state.flatPositionTree[index];
                        return _buildTreeNodeRow(node, vm);
                      },
                    ),
                  ),

                  // Выбор сотрудников
                  const SizedBox(height: 15),
                  Text('Выбор сотрудников:', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: _bgOffBlack, border: Border.all(color: _bgGray950), borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      children: [
                        Text('Авто-подбор:', style: TextStyle(color: _textColor)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _autoSelectWorkerController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _updateViewModelFields(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: _textColor),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: _bgGray950,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('чел.', style: TextStyle(color: Colors.white54)),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => vm.autoSelectEmployeesAsync(),
                          style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
                          child: const Text('Подобрать', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text('Ручной выбор / Доступные:', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      itemCount: state.selectableEmployees.length,
                      itemBuilder: (context, index) {
                        final emp = state.selectableEmployees[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Checkbox(
                                value: emp.isSelected,
                                onChanged: (val) => vm.toggleEmployeeSelected(emp, val ?? false),
                                activeColor: _primaryColor,
                              ),
                              Text(emp.item.fullName, style: TextStyle(color: _textColor)),
                              const SizedBox(width: 10),
                              Text('(Задач: ${emp.item.activeTasksCount})', style: const TextStyle(color: Colors.white54)),
                              if (emp.item.isRecommended)
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Icon(Icons.star, color: Colors.amber, size: 16),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async {
                      final success = await vm.createInventoryAsync();
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Задача успешно создана')),
                        );
                        _descriptionController.clear();
                        _workerCountController.text = '1';
                        _priorityController.text = '5';
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('Отправить задачу', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  if (state.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(state.errorMessage, style: const TextStyle(color: Colors.red)),
                    ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeNodeRow(SelectableTreeNode node, BossPanelViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: Row(
        children: [
          SizedBox(width: node.level * 20.0), // Отступ в зависимости от уровня
          if (node.hasChildren)
            InkWell(
              onTap: () => vm.toggleNodeExpanded(node),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  node.isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                  color: _gray400,
                  size: 20,
                ),
              ),
            )
          else
            const SizedBox(width: 28), // Placeholder for leaf nodes
          
          Checkbox(
            value: node.isSelected,
            onChanged: (val) => vm.toggleNodeSelected(node, val ?? false),
            activeColor: _primaryColor,
            visualDensity: VisualDensity.compact,
          ),
          
          Expanded(
            child: InkWell(
              onTap: () => vm.toggleNodeExpanded(node),
              child: Text(
                node.title,
                style: TextStyle(color: _textColor, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeesTab(BossPanelState state, BossPanelViewModel vm) {
    return RefreshIndicator(
      onRefresh: () => vm.loadDataAsync(),
      child: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: state.employeeWorkloads.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Text(
                'Нагрузка сотрудников и статус',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }
          final emp = state.employeeWorkloads[index - 1];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: _bgGray900, borderRadius: BorderRadius.circular(8)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(emp.fullName, style: TextStyle(color: _textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 10, height: 10,
                            decoration: BoxDecoration(
                              color: emp.isAtWork ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(emp.isAtWork ? 'На смене' : 'Не на смене', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                      if (emp.hasActiveTasks) ...[
                        const SizedBox(height: 10),
                        const Text('Текущие задачи:', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ...emp.activeTasks.map((t) => Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text('- ${t.title}', style: const TextStyle(color: Color(0xFFD1D5DB), fontSize: 12)),
                        )),
                      ]
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(emp.activeTasksCount.toString(), style: TextStyle(color: _primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text('Активных\nзадач', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 10)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
