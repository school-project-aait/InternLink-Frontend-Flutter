import '../../../../core/utils/resource.dart';
import '../../domain/entities/application.dart';

class ApplicationListState {
  final Resource<List<Application>> applications;
  final bool isRefreshing;

  ApplicationListState({
    this.applications = const ResourceLoading(),
    this.isRefreshing = false,
  });

  ApplicationListState copyWith({
    Resource<List<Application>>? applications,
    bool? isRefreshing,
  }) {
    return ApplicationListState(
      applications: applications ?? this.applications,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}
