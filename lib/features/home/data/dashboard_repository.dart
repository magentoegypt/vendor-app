// throw an Exception while looking for the Store Info Data
import '../../../features/home/data/DashboarModel.dart';
import '../../../features/home/data/UserModel.dart';
import '../../../features/home/data/dasboard_api_service.dart';

class DasboardRepositoryException implements Exception {}

class DashboardRepository {
  DashboardRepository({DasboardApiService? service})
      : _service = service ??  DasboardApiService();
  final  DasboardApiService _service;

  Future<DashboarModel> requestDashboard() async {
    try {
      return _service.getDashboardData();
    } on Exception {
      throw DasboardRepositoryException();
    }
  }

  Future<UserModel> requestUserDetail() async {
    try {
      return _service.getUserData();
    } on Exception {
      throw DasboardRepositoryException();
    }
  }
}
