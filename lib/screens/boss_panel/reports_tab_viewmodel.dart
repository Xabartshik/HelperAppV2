import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import '../../core/network/api_client.dart';
import '../../core/utils/logger.dart';

class ReportsTabState {
  final DateTime startDate;
  final DateTime endDate;
  final bool isDownloading;
  final String? errorMessage;
  final String? successMessage;

  ReportsTabState({
    required this.startDate,
    required this.endDate,
    this.isDownloading = false,
    this.errorMessage,
    this.successMessage,
  });

  ReportsTabState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    bool? isDownloading,
    String? errorMessage,
    String? successMessage,
  }) {
    return ReportsTabState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isDownloading: isDownloading ?? this.isDownloading,
      // Если передаем null, обнуляем ошибки
      errorMessage: errorMessage, 
      successMessage: successMessage,
    );
  }
}

final reportsTabViewModelProvider = AutoDisposeNotifierProvider<ReportsTabViewModel, ReportsTabState>(() {
  return ReportsTabViewModel();
});

class ReportsTabViewModel extends AutoDisposeNotifier<ReportsTabState> {
  @override
  ReportsTabState build() {
    // По умолчанию: за последние 30 дней
    final now = DateTime.now();
    return ReportsTabState(
      startDate: now.subtract(const Duration(days: 30)),
      endDate: now,
    );
  }

  void setDateRange(DateTime start, DateTime end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }

  Future<void> downloadReport(String endpoint, String fileName, String extension) async {
    state = state.copyWith(isDownloading: true, errorMessage: null, successMessage: null);

    try {
      final client = ref.read(apiClientProvider);
      
      final bytes = await client.downloadReportBytesAsync(
        endpoint, 
        state.startDate, 
        state.endDate,
      );

      if (bytes == null || bytes.isEmpty) {
        state = state.copyWith(isDownloading: false, errorMessage: 'Сервер вернул пустой файл');
        return;
      }

      // 1. Получаем директорию для сохранения
      final dir = await getApplicationDocumentsDirectory();
      
      // 2. Формируем уникальное имя файла
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${dir.path}/${fileName}_$timestamp.$extension');
      
      // 3. Записываем байты
      await file.writeAsBytes(bytes);

      state = state.copyWith(
        isDownloading: false, 
        successMessage: 'Отчет сохранен',
      );

      // 4. Открываем файл системной утилитой
      final result = await OpenFilex.open(file.path);
      if (result.type != ResultType.done) {
        state = state.copyWith(
          isDownloading: false, 
          errorMessage: 'Не удалось открыть файл: ${result.message}',
        );
      }

    } catch (e) {
      Logger.e('Ошибка при скачивании отчета', e);
      state = state.copyWith(
        isDownloading: false,
        errorMessage: 'Ошибка скачивания: $e',
      );
    }
  }
}