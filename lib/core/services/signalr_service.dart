import 'package:signalr_netcore/signalr_client.dart';
import '../utils/logger.dart';

class SignalRService {
  HubConnection? _hubConnection;
  
  /// Коллбек, который вызывает UI (MainPage) для показа оверлея/снекбара 
  /// и обновления списка задач.
  Function(String title, String message, String type)? onNotificationReceived;

  bool _isConnectionIntended = false;

  /// Инициализация подключения к SignalR хабу
  Future<void> initConnection(int workerId, String serverUrl) async {
    _isConnectionIntended = true;
    final url = '$serverUrl/hubs/task-notifications';

    _hubConnection = HubConnectionBuilder()
        .withUrl(url)
        .withAutomaticReconnect() 
        .build();

    _hubConnection?.on('ReceiveNotification', _handleNotification);

    // Логируем успешное переподключение
    _hubConnection?.onreconnected(({connectionId}) async {
      Logger.i('SignalR: Переподключились! Новый ID: $connectionId');
      // Заново добавляем себя в группу после обрыва сети
      try {
        await _hubConnection?.invoke('RegisterWorker', args: [workerId]);
        Logger.i('SignalR: Работник $workerId заново зарегистрирован в группе.');
      } catch (e) {
        Logger.i('SignalR: Ошибка перерегистрации $e');
      }
    });

    int retryCount = 0;
    while (_isConnectionIntended && _hubConnection?.state != HubConnectionState.Connected) {
      try {
        await _hubConnection?.start();
        Logger.i('SignalR Успешно подключен к $url');
        
        // Первичная регистрация
        await _hubConnection?.invoke('RegisterWorker', args: [workerId]);
        Logger.i('Работник $workerId зарегистрирован для получения PUSH-уведомлений.');
      } catch (e) {
        retryCount++;
        Logger.i('Ошибка подключения SignalR (попытка $retryCount): $e. Повторная попытка через 5 секунд...');
        if (_isConnectionIntended) {
          await Future.delayed(const Duration(seconds: 5));
        }
      }
    }
  }

  /// Проверяет и восстанавливает соединение при необходимости
  Future<void> ensureConnected(int workerId, String serverUrl) async {
    if (!_isConnectionIntended) return;
    if (_hubConnection == null || _hubConnection?.state == HubConnectionState.Disconnected) {
      Logger.i('SignalR: Обнаружено отсутствие подключения. Попытка переподключения...');
      await initConnection(workerId, serverUrl);
    }
  }

  /// Внутренний обработчик входящих сообщений от сервера
  void _handleNotification(List<dynamic>? parameters) {
    Logger.i('СЫРЫЕ ДАННЫЕ ИЗ SIGNALR: $parameters');
    if (parameters != null && parameters.isNotEmpty) {
      try {
        // Безопасное преобразование параметров в карту
        final data = Map<String, dynamic>.from(parameters[0] as Map);
        
        // Извлекаем данные с фолбэками по умолчанию
        final title = data['title']?.toString() ?? data['Title']?.toString() ?? 'Уведомление';
        final message = data['message']?.toString() ?? data['Message']?.toString() ?? '';
        final type = data['type']?.toString() ?? data['Type']?.toString() ?? 'info';

        Logger.i('SignalR: Получено PUSH-уведомление: $title - $message (Тип: $type)');

        // Передаем данные в UI
        if (onNotificationReceived != null) {
          onNotificationReceived!(title, message, type);
        }
      } catch (e, stack) {
        Logger.e('Ошибка при обработке полученного уведомления SignalR', e, stack);
      }
    }
  }

  /// Корректное отключение при выходе из профиля
  Future<void> stopConnection(int workerId) async {
    _isConnectionIntended = false;
    if (_hubConnection?.state == HubConnectionState.Connected) {
      try {
        // Удаляем из группы на сервере
        await _hubConnection?.invoke('UnregisterWorker', args: [workerId]);
        // Закрываем само соединение
        await _hubConnection?.stop();
        Logger.i('SignalR отключен, работник $workerId удален из хаба.');
      } catch (e) {
        Logger.e('Ошибка при отключении SignalR: $e');
      }
    }
  }
}