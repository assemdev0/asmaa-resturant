import '/data/api/api_client.dart';
import '/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class BannerRepo {
  final ApiClient apiClient;
  BannerRepo({required this.apiClient});

  Future<Response> getBannerList() async {
    return await apiClient.getData(AppConstants.bannerUri);
  }
}
