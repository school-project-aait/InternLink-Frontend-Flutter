// lib/data/models/base_response.dart

class BaseResponseStatus {
  final bool success;
  final String? message;

  BaseResponseStatus({required this.success, this.message});

  factory BaseResponseStatus.fromJson(Map<String, dynamic> json) {
    return BaseResponseStatus(
      success: json['success'] ?? false,
      message: json['message'],
    );
  }
}
