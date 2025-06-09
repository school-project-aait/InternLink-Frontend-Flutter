class ApiEndpoints {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String addInternship = '/internships'; // POST
  static const String editInternship = '/internships'; // PUT
  static const String getDropdownData = '/internships/dropdown-data';

  static String editInternshipRoute(int id) => '$editInternship/$id'; // Correct: becomes '/internships/:id'
  static const String getApplications = '/applications'; // GET all applications

  // PATCH update application status by ID
  static String updateApplicationStatus(int id) => '/applications/$id/status';
}