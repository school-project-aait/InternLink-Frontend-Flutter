// lib/data/models/update_status_request.dart

class UpdateStatusRequest {
  final String status;

  UpdateStatusRequest({required this.status});

  Map<String, dynamic> toJson() {
    return {
      'status': status,
    };
  }
}
