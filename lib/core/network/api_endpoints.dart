/// Единый реестр всех эндпоинтов API.
/// Все пути гарантированно используют префикс v1/ или абсолютные пути API, если это требуется контрактом.
class ApiEndpoints {
  // Auth
  static const String login = 'v1/mobileappuser/login';
  static const String register = 'v1/mobileappuser/register';

  // Worker Tasks (Aggregator)
  static String workerTasksPending(int employeeId) => 'v1/WorkerTasks/$employeeId/pending';
  static String workerTaskStart(int taskId, int workerId) => 'v1/WorkerTasks/$taskId/start?workerId=$workerId';
  static String workerTaskDetails(int taskId, int workerId) => 
      'v1/WorkerTasks/$workerId/$taskId/details';
  static String workerTaskPause(int taskId, int workerId) => 'v1/WorkerTasks/$taskId/pause?workerId=$workerId';
  static String workerTaskCancel(int taskId, int workerId) => 'v1/WorkerTasks/$taskId/cancel?workerId=$workerId';
  // Общий пул задач
static String globalPoolTasks(int branchId) => 'v1/WorkerTasks/$branchId/pool';
  static String claimPoolTask(int taskId, int workerId) => 'v1/WorkerTasks/$taskId/claim?workerId=$workerId';


// // Обновленный метод для деталей (теперь использует путь /workerId/taskId/details)
// static String workerTaskDetails(int taskId, int workerId) => 
//     'v1/WorkerTasks/$workerId/$taskId/details';

  // Boss Panel
  static const String bossPanelActiveTasks = 'v1/bosspanel/tasks/active';
  static const String bossPanelEmployeeWorkload = 'v1/bosspanel/employees/workload';
  static const String bossPanelAvailableEmployees = 'v1/bosspanel/employees/available';
  static const String bossPanelPositions = 'v1/bosspanel/positions';
  static String bossPanelAutoSelectEmployees(int count) => 'v1/bosspanel/employees/auto-select?count=$count';
  static const String bossPanelCreateInventoryByZone = 'v1/bosspanel/inventory/create-by-zone';
  static const String bossPanelAvailableOrders = 'v1/bosspanel/orders/available';
  static const String bossPanelCreateOrderAssembly = 'v1/bosspanel/tasks/order-assembly/create';
  // Добавь в блок Boss Panel:
  static const String bossPanelAvailableCouriers = 'v1/bosspanel/couriers/available';
  static const String bossPanelReadyOrders = 'v1/bosspanel/orders/ready-for-dispatch';
  
  // Добавь туда же, где у тебя лежит initCustomerHandover:
  static const String initCourierBatchHandover = 'v1/OrderHandover/init-courier-batch';

  // Inventory
  static String inventoryTaskDetails(int assignmentId) => 'v1/Inventory/assignment/$assignmentId/details';
  static const String inventoryCompleteAssignment = 'v1/Inventory/complete-assignment';
  static const String inventoryProcessScan = 'v1/Inventory/scan';
  static String itemInfo(int itemId) => 'v1/Item/$itemId';

  // Order Assembly
  static String orderAssemblyTasks(int userId) => 'v1/OrderAssembly/worker/$userId/assignments';
  static String orderAssemblyDetails(int id) => 'v1/OrderAssembly/assignment/$id/details';
  static String orderAssemblyStart(int id) => 'v1/OrderAssembly/assignment/$id/start';
  static String orderAssemblyPause(int id) => 'v1/OrderAssembly/assignment/$id/pause';
  static String orderAssemblyCancel(int id) => 'v1/OrderAssembly/assignment/$id/cancel';
  static const String orderAssemblyScanPick = 'v1/OrderAssembly/scan-pick';
  static const String orderAssemblyScanPlaceBulk = 'v1/OrderAssembly/scan-place-bulk';
  static const String orderAssemblyReportMissing = 'v1/OrderAssembly/report-missing';
  static String orderAssemblyComplete(int assignmentId) => 'v1/OrderAssembly/complete/$assignmentId';

  static String customerOrders(int customerId) => 'orders/customer/$customerId';
  static String orderDetails(int orderId) => 'orders/$orderId';
  // Create Order (Customer simulator)
  static const String getBranches = 'Branches'; // GET /api/Branch
  static String getAvailableItems(int branchId, {String query = ''}) =>
      'ItemPosition/available/$branchId?search=${Uri.encodeQueryComponent(query)}';
  static const String getPostamats = 'Postamat'; // GET /api/Postamat
  static const String checkPostamatCapacity = 'Postamat/check-capacity'; // POST /api/Postamat/check-capacity
  static const String createOrder = 'Orders'; // POST /api/Orders
  static const String qrCheckInScan = 'QrCheckIn/scan';
  static String lastCheck(int employeeId) => 'CheckIOEmployee/last/$employeeId';
  static const String getConfig = 'v1/Config'; // GET /api/v1/Config
  static String workerTaskComplete(int taskId, int workerId) => 
      'v1/WorkerTasks/$taskId/complete?workerId=$workerId';
  // НОВЫЙ ЭНДПОИНТ ДЛЯ ЭКСПРЕСС-ВЫДАЧИ
  static String orderAssemblyExpressHandover(int assignmentId) => 'v1/OrderAssembly/assignment/$assignmentId/express-handover';
      // Worker Breaks (Охрана труда)
  static String breakStatus(int employeeId) => 'workers/$employeeId/breaks/status';
  static String startBreak(int employeeId) => 'workers/$employeeId/breaks/start';
  static String endBreak(int employeeId) => 'workers/$employeeId/breaks/end';

// НОВЫЙ ЭНДПОИНТ: Специфичный метод для OrderHandover
  static String orderHandoverScan(int taskId, int workerId) => 
    'v1/OrderHandover/$taskId/scan?workerId=$workerId';
    static const String initCustomerHandover = 'v1/OrderHandover/init-customer';
    // Специфичный метод для закрытия задачи курьера по QR
  static String orderHandoverCompleteCourier(int taskId) => 
      'v1/OrderHandover/$taskId/complete-courier';
}
