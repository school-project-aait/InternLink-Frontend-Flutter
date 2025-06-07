class ApiEndpoints {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  static const String login = '/auth/login';
  static const String addInternship = '/admin/internships/add';
  static const String editInternship = '/admin/internships/edit';
  static const String getDropdownData = '/api/internships/dropdown-data';



  static String editInternshipRoute(int id) => '$editInternship/$id';
}