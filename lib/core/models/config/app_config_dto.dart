class AppConfigDto {
  final double pickupWindowLimitHours;
  final double deliveryWindowLimitHours;
  final double weightCoefficient;
  
  // Новые поля для системы перерывов
  final int maxConcurrentBreaksPercentage;
  final int breakDurationMinutes;
  final int workMinutesRequiredForBreak;
  final bool useUnifiedWorkerTasksApi;

  AppConfigDto({
    required this.pickupWindowLimitHours,
    required this.deliveryWindowLimitHours,
    required this.weightCoefficient,
    required this.maxConcurrentBreaksPercentage,
    required this.breakDurationMinutes,
    required this.workMinutesRequiredForBreak,
    required this.useUnifiedWorkerTasksApi,
  });

  factory AppConfigDto.fromJson(Map<String, dynamic> json) {
    return AppConfigDto(
      // Указываем дефолтные значения на случай сбоев парсинга
      pickupWindowLimitHours: (json['pickupWindowLimitHours'] as num?)?.toDouble() ?? 0.5, 
      deliveryWindowLimitHours: (json['deliveryWindowLimitHours'] as num?)?.toDouble() ?? 1.0,
      weightCoefficient: (json['weightCoefficient'] as num?)?.toDouble() ?? 1.0,
      
      // Дефолтные значения для перерывов из бэкенда
      maxConcurrentBreaksPercentage: (json['maxConcurrentBreaksPercentage'] as num?)?.toInt() ?? 20,
      breakDurationMinutes: (json['breakDurationMinutes'] as num?)?.toInt() ?? 10,
      workMinutesRequiredForBreak: (json['workMinutesRequiredForBreak'] as num?)?.toInt() ?? 60,
      useUnifiedWorkerTasksApi: json['useUnifiedWorkerTasksApi'] as bool? ?? true,
    );
  }
}
