class BaseResponse<T> {
  final bool success;
  final String message;
  final T? domain;

  BaseResponse({
    required this.success,
    required this.message,
    this.domain,
  });

  factory BaseResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return BaseResponse(
      success: json['success'],
      message: json['message'],
      domain: json['domain'] != null ? fromJsonT(json['domain']) : null,
    );
  }
}