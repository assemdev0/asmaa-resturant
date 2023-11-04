import 'package:carousel_slider/carousel_slider.dart';
import '/controller/banner_controller.dart';
import '/controller/splash_controller.dart';
import '/data/model/response/basic_campaign_model.dart';
import '/data/model/response/product_model.dart';
import '/data/model/response/restaurant_model.dart';
import '/helper/responsive_helper.dart';
import '/helper/route_helper.dart';
import '/util/dimensions.dart';
import '/view/base/custom_image.dart';
import '/view/base/product_bottom_sheet.dart';
import '/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerView1 extends StatelessWidget {
  const BannerView1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(builder: (bannerController) {
      List<String?>? bannerList = bannerController.bannerImageList;
      List<dynamic>? bannerDataList = bannerController.bannerDataList;

      return (bannerList != null && bannerList.isEmpty)
          ? const SizedBox()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: GetPlatform.isDesktop
                  ? 500
                  : MediaQuery.of(context).size.width * 0.45,
              padding:
                  const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
              child: bannerList != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              disableCenter: true,
                              viewportFraction: 0.95,
                              autoPlayInterval: const Duration(seconds: 7),
                              onPageChanged: (index, reason) {
                                bannerController.setCurrentIndex(index, true);
                              },
                            ),
                            itemCount:
                                bannerList.isEmpty ? 1 : bannerList.length,
                            itemBuilder: (context, index, _) {
                              String? baseUrl =
                                  bannerDataList![index] is BasicCampaignModel
                                      ? Get.find<SplashController>()
                                          .configModel!
                                          .baseUrls!
                                          .campaignImageUrl
                                      : Get.find<SplashController>()
                                          .configModel!
                                          .baseUrls!
                                          .bannerImageUrl;
                              return InkWell(
                                onTap: () {
                                  if (bannerDataList[index] is Product) {
                                    Product? product = bannerDataList[index];
                                    ResponsiveHelper.isMobile(context)
                                        ? showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (con) =>
                                                ProductBottomSheet(
                                                    product: product),
                                          )
                                        : showDialog(
                                            context: context,
                                            builder: (con) => Dialog(
                                                child: ProductBottomSheet(
                                                    product: product)),
                                          );
                                  } else if (bannerDataList[index]
                                      is Restaurant) {
                                    Restaurant restaurant =
                                        bannerDataList[index];
                                    Get.toNamed(
                                      RouteHelper.getRestaurantRoute(
                                          restaurant.id),
                                      arguments: RestaurantScreen(
                                          restaurant: restaurant),
                                    );
                                  } else if (bannerDataList[index]
                                      is BasicCampaignModel) {
                                    BasicCampaignModel campaign =
                                        bannerDataList[index];
                                    Get.toNamed(
                                        RouteHelper.getBasicCampaignRoute(
                                            campaign));
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[
                                              Get.isDarkMode ? 800 : 200]!,
                                          spreadRadius: 1,
                                          blurRadius: 5)
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                    child: GetBuilder<SplashController>(
                                        builder: (splashController) {
                                      return CustomImage(
                                        image: '$baseUrl/${bannerList[index]}',
                                        fit: BoxFit.cover,
                                      );
                                    }),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: bannerList.map((bnr) {
                            int index = bannerList.indexOf(bnr);
                            return TabPageSelectorIndicator(
                              backgroundColor:
                                  index == bannerController.currentIndex
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5),
                              borderColor:
                                  Theme.of(context).colorScheme.background,
                              size: index == bannerController.currentIndex
                                  ? 10
                                  : 7,
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  : Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: bannerList == null,
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            color: Colors.grey[300],
                          )),
                    ),
            );
    });
  }
}
