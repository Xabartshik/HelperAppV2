import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/models/tasks/mobile_base_task_dto.dart';
import 'package:helper_app/core/network/api_client.dart';

class AssignmentDetailsState {
  final bool isLoading;
  final MobileBaseTaskDto? task;
  final String? error;

  AssignmentDetailsState({
    this.isLoading = false,
    this.task,
    this.error,
  });

  AssignmentDetailsState copyWith({
    bool? isLoading,
    MobileBaseTaskDto? task,
    String? error,
  }) {
    return AssignmentDetailsState(
      isLoading: isLoading ?? this.isLoading,
      task: task ?? this.task,
      error: error ?? this.error,
    );
  }
}

class AssignmentDetailsViewModel extends StateNotifier<AssignmentDetailsState> {
  final Ref ref;
  final int workerId;
  final int taskId;

  AssignmentDetailsViewModel(this.ref, this.workerId, this.taskId) : super(AssignmentDetailsState()) {
    loadDetails();
  }

  Future<void> loadDetails() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final client = ref.read(apiClientProvider);
      final rawData = await client.getWorkerTaskDetailsAsync(workerId, taskId);
      final task = MobileBaseTaskDto.fromJson(rawData as Map<String, dynamic>);
      state = state.copyWith(isLoading: false, task: task);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final assignmentDetailsViewModelProvider = StateNotifierProvider.family<AssignmentDetailsViewModel, AssignmentDetailsState, ({int workerId, int taskId})>((ref, args) {
  return AssignmentDetailsViewModel(ref, args.workerId, args.taskId);
});
