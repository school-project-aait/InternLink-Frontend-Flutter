// application_list_notifier.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/resource.dart';
import '../../domain/entities/application.dart';
import '../../domain/usecases/delete_application.dart';
import '../../domain/usecases/get_user_application.dart';

import 'application_list_state.dart';

class ApplicationListNotifier extends StateNotifier<ApplicationListState> {
  final GetUserApplications _getUserApplications;
  final DeleteApplication _deleteApplication;
  final Ref _ref;

  ApplicationListNotifier(
      this._getUserApplications,
      this._deleteApplication,
      this._ref,
      ) : super(ApplicationListState()) {
    loadApplications();
  }

  Future<void> loadApplications() async {
    state = state.copyWith(
      applications: const ResourceLoading(),
      isRefreshing: false,
    );

    final result = await _getUserApplications();
    state = state.copyWith(applications: result);
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);
    await loadApplications();
  }

  Future<void> deleteApplication(int applicationId) async {
    final result = await _deleteApplication(applicationId);
    result.when(
      success: (_) => loadApplications(),
      error: (message, _) => debugPrint(message),
      loading: () => null,
    );
  }
}

final applicationListProvider =
StateNotifierProvider<ApplicationListNotifier, ApplicationListState>((ref) {
  return ApplicationListNotifier(
    ref.read(getUserApplicationsProvider),
    ref.read(deleteApplicationProvider),
    ref,
  );
});