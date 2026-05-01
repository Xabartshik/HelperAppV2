# helper_app

A new Flutter project.

## Добавление нового task type

1. **DTO от бэкенда**: базовая структура задачи приходит в `lib/core/models/tasks/mobile_base_task_dto.dart` (`taskType`, `taskDetails`, статусы и метаданные).
2. **Адаптер типа задачи**: создайте отдельный модуль в `lib/core/tasks/` (по примеру `inventory_adapter.dart` и `order_assembly_adapter.dart`) и реализуйте интерфейс `TaskTypeAdapter` из `lib/core/tasks/task_type_adapter.dart`:
   - `parseListItem(MobileBaseTaskDto dto, int employeeId)`
   - `parseDetails(MobileBaseTaskDto dto, int employeeId)`
   - `buildNavigationPayload(TaskCardVm taskCard, int employeeId)`
3. **Регистрация адаптера**: добавьте новый адаптер в реестр `lib/core/tasks/task_registry.dart` (ключ — `taskType.toLowerCase()`).
4. **Экран задачи**: создайте/подключите экран в `lib/screens/...` для нового типа задачи.
5. **Маршрутизация**:
   - добавьте роут в `lib/core/router/app_router.dart`;
   - верните путь и `extra` в `buildNavigationPayload` адаптера;
   - `MainPage` использует единый `TaskNavigationDispatcher`, поэтому ручные if/else по типам задач не требуются.
