import '/data/api/api_client.dart';
import '/helper/route_helper.dart';
import '/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

class WalletRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  WalletRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getWalletTransactionList(
      String offset, String sortingType) async {
    return await apiClient.getData(
        '${AppConstants.walletTransactionUri}?offset=$offset&limit=10&type=$sortingType');
  }

  Future<Response> getLoyaltyTransactionList(String offset) async {
    return await apiClient.getData(
        '${AppConstants.loyaltyTransactionUri}?offset=$offset&limit=10');
  }

  Future<Response> pointToWallet({int? point}) async {
    return await apiClient
        .postData(AppConstants.loyaltyPointTransferUri, {"point": point});
  }

  Future<Response> addFundToWallet(double amount, String paymentMethod) async {
    String? hostname = html.window.location.hostname;
    String protocol = html.window.location.protocol;

    return await apiClient.postData(AppConstants.addFundUri, {
      "amount": amount,
      "payment_method": paymentMethod,
      "payment_platform": GetPlatform.isWeb ? 'web' : '',
      "callback": '$protocol//$hostname${RouteHelper.wallet}',
    });
  }

  Future<Response> getWalletBonusList() async {
    return await apiClient.getData(AppConstants.walletBonusUri);
  }

  Future<void> setWalletAccessToken(String token) {
    return sharedPreferences.setString(AppConstants.walletAccessToken, token);
  }

  String getWalletAccessToken() {
    return sharedPreferences.getString(AppConstants.walletAccessToken) ?? "";
  }
}
