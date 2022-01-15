import 'package:bloc_list_view/services/data_service.dart';
import 'package:bloc_list_view/features/home/models/square.dart';
import 'package:dio/dio.dart';

class HomeRepo {
  Dio _dio;

  static DataService apiService;

  HomeRepo() {
    apiService = DataService();
  }

  Future<Square> fetchSquares(int page) async {
    final squareUrl = "square/repos?page=$page&per_page=20";

    Square square = Square();
    try {
      final response = await apiService.request(
          endpoint: squareUrl, requestType: RequestType.GET);

      Map<String, dynamic> responseMap = {"square": response.data};
      square = Square.fromMap(responseMap);

      return square;
    } on DioError catch (e) {
      throw e.error;
    } catch (e) {}
    return square;
  }
}
