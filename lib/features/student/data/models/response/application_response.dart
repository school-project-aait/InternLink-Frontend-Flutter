class ApplicationResponse {
  final bool success;
  final ApplicationData data;
  final String? message;

  ApplicationResponse({
    required this.success,
    required this.data,
    this.message,
  });

  factory ApplicationResponse.fromJson(Map<String, dynamic> json) {
    return ApplicationResponse(
      success: json['success'],
      data: ApplicationData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class ApplicationData {
  final int applicationId;
  final String? internshipTitle;
  final String? companyName;

  ApplicationData({
    required this.applicationId,
    this.internshipTitle,
    this.companyName,
  });

  factory ApplicationData.fromJson(Map<String, dynamic> json) {
    return ApplicationData(
      applicationId: json['applicationId'],
      internshipTitle: json['internshipTitle'],
      companyName: json['companyName'],
    );
  }
}