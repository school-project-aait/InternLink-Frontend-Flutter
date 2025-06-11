import 'package:internlink_flutter_application/features/admin/data/datasources/remote/internship_api_service.dart';
import 'package:internlink_flutter_application/features/student/domain/usecases/delete_application.dart';
import 'package:internlink_flutter_application/features/student/domain/usecases/get_user_application.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  InternshipApiService,
  GetUserApplications,
  DeleteApplication,
])
void main() {}
