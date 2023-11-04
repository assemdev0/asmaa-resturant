import '/data/api/api_checker.dart';
import '/data/model/response/banner_model.dart';
import '/data/repository/banner_repo.dart';
import '/helper/responsive_helper.dart';
import 'package:get/get.dart';

class BannerController extends GetxController implements GetxService {
  final BannerRepo bannerRepo;
  BannerController({required this.bannerRepo});

  List<String?>? _bannerImageList;
  List<dynamic>? _bannerDataList;
  int _currentIndex = 0;

  List<String?>? get bannerImageList => _bannerImageList;
  List<dynamic>? get bannerDataList => _bannerDataList;
  int get currentIndex => _currentIndex;

  Future<void> getBannerList(bool reload) async {
    if (_bannerImageList == null || reload) {
      Response response = await bannerRepo.getBannerList();
      if (response.statusCode == 200) {
        _bannerImageList = [];
        _bannerDataList = [];
        BannerModel bannerModel = BannerModel.fromJson(response.body);
        for (var campaign in bannerModel.campaigns!) {
          _bannerImageList!.add(campaign.image);
          _bannerDataList!.add(campaign);
        }
        for (var banner in bannerModel.banners!) {
          _bannerImageList!.add(banner.image);
          if (banner.food != null) {
            _bannerDataList!.add(banner.food);
          } else {
            _bannerDataList!.add(banner.restaurant);
          }
        }
        if (ResponsiveHelper.isDesktop(Get.context) &&
            _bannerImageList!.length % 2 != 0) {
          _bannerImageList!.add(_bannerImageList![0]);
          _bannerDataList!.add(_bannerDataList![0]);
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if (notify) {
      update();
    }
  }
}
