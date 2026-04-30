import 'package:signalr_netcore/signalr_client.dart';
import '../utils/logger.dart';

class SignalRService {
  HubConnection? _hubConnection;
  
  /// Коллбек, который вызывает UI (MainPage) для показа оверлея/снекбара 
  /// и обновления списка задач.
  Function(String title, String message, String type)? onNotificationReceived;

  /// Инициализация подключения к SignalR хабу
  Future<void> initConnection(int workerId, String serverUrl) async {
    // Формируем полный URL до хаба
    final url = '$serverUrl/hubs/task-notifications';

    // Создаем подключение с автоматическим восстановлением связи
    _hubConnection = HubConnectionBuilder()
        .withUrl(url)
        .withAutomaticReconnect() 
        .build();

    // Подписываемся на метод "ReceiveNotification", который вызывает бэкенд
    _hubConnection?.on('ReceiveNotification', _handleNotification);

    try {
      await _hubConnection?.start();
      Logger.i('SignalR Успешно подключен к $url');
      
      // Регистрируем работника на сервере, чтобы он попал в свою персональную группу
      await _hubConnection?.invoke('RegisterWorker', args: [workerId]);
      Logger.i('Работник $workerId зарегистрирован для получения PUSH-уведомлений.');
      
    } catch (e) {
      Logger.e('Ошибка подключения SignalR: $e');
    }
  }

  /// Внутренний обработчик входящих сообщений от сервера
  void _handleNotification(List<dynamic>? parameters) {
    if (parameters != null && parameters.isNotEmpty) {
      // SignalR передает C# объекты как Map<String, dynamic> в первом аргументе
      final data = parameters[0] as Map<String, dynamic>;
      
      // Извлекаем данные с фолбэками по умолчанию
      // Важно: ключи зависят от настроек сериализации на C# (обычно camelCase)
      final title = data['title']?.toString() ?? data['Title']?.toString() ?? 'Уведомление';
      final message = data['message']?.toString() ?? data['Message']?.toString() ?? '';
      final type = data['type']?.toString() ?? data['Type']?.toString() ?? 'info';

      Logger.i('SignalR: Получено PUSH-уведомление: $title - $message (Тип: $type)');

      // Передаем данные в UI (в MainPage), если страница сейчас активна и слушает
      if (onNotificationReceived != null) {
        onNotificationReceived!(title, message, type);
      }
    }
  }

  /// Корректное отключение (вызывать при логауте или закрытии приложения)
  Future<void> stopConnection(int workerId) async {
    if (_hubConnection?.state == HubConnectionState.Connected) {
      try {
        // Сначала удаляем из группы на сервере
        await _hubConnection?.invoke('UnregisterWorker', args: [workerId]);
        // Затем закрываем само соединение
        await _hubConnection?.stop();
        Logger.i('SignalR отключен, работник $workerId удален из хаба.');
      } catch (e) {
        Logger.e('Ошибка при отключении SignalR: $e');
      }
    }
  }
}