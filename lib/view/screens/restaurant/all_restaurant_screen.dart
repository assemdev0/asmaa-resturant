import '/controller/restaurant_controller.dart';
import '/util/app_constants.dart';
import '/util/dimensions.dart';
import '/view/base/custom_app_bar.dart';
import '/view/base/footer_view.dart';
import '/view/base/menu_drawer.dart';
import '/view/base/product_view.dart';
import '/view/base/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllRestaurantScreen extends StatefulWidget {
  final bool isPopular;
  final bool isRecentlyViewed;
  final bool isOrderAgain;
  const AllRestaurantScreen(
      {Key? key,
      required this.isPopular,
      required this.isRecentlyViewed,
      required this.isOrderAgain})
      : super(key: key);

  @override
  State<AllRestaurantScreen> createState() => _AllRestaurantScreenState();
}

class _AllRestaurantScreenState extends State<AllRestaurantScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (widget.isPopular) {
      Get.find<RestaurantController>()
          .getPopularRestaurantList(false, 'all', false);
    } else if (widget.isRecentlyViewed) {
      Get.find<RestaurantController>()
          .getRecentlyViewedRestaurantList(false, 'all', false);
    } else if (widget.isOrderAgain) {
      Get.find<RestaurantController>().getOrderAgainRestaurantList(false);
    } else {
      Get.find<RestaurantController>()
          .getLatestRestaurantList(false, 'all', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return Scaffold(
        appBar: CustomAppBar(
          title: widget.isPopular
              ? 'popular_restaurants'.tr
              : widget.isRecentlyViewed
                  ? 'recently_viewed_restaurants'.tr
                  : widget.isOrderAgain
                      ? 'order_again'.tr
                      : '${'new_on'.tr} ${AppConstants.appName}',
          type: restController.type,
          onVegFilterTap: widget.isOrderAgain
              ? null
              : (String type) {
                  if (widget.isPopular) {
                    restController.getPopularRestaurantList(true, type, true);
                  } else {
                    if (widget.isRecentlyViewed) {
                      restController.getRecentlyViewedRestaurantList(
                          true, type, true);
                    } else {
                      restController.getLatestRestaurantList(true, type, true);
                    }
                  }
                },
        ),
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        body: RefreshIndicator(
          onRefresh: () async {
            if (widget.isPopular) {
              await Get.find<RestaurantController>().getPopularRestaurantList(
                true,
                Get.find<RestaurantController>().type,
                false,
              );
            } else if (widget.isRecentlyViewed) {
              Get.find<RestaurantController>().getRecentlyViewedRestaurantList(
                  true, Get.find<RestaurantController>().type, false);
            } else if (widget.isOrderAgain) {
              Get.find<RestaurantController>()
                  .getOrderAgainRestaurantList(false);
            } else {
              await Get.find<RestaurantController>().getLatestRestaurantList(
                  true, Get.find<RestaurantController>().type, false);
            }
          },
          child: Scrollbar(
              controller: scrollController,
              child: SingleChildScrollView(
                  controller: scrollController,
                  child: FooterView(
                    child: Column(
                      children: [
                        WebScreenTitleWidget(title: 'restaurants'.tr),
                        Center(
                            child: SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: ProductView(
                            isRestaurant: true,
                            products: null,
                            noDataText: 'no_restaurant_available'.tr,
                            restaurants: widget.isPopular
                                ? restController.popularRestaurantList
                                : widget.isRecentlyViewed
                                    ? restController
                                        .recentlyViewedRestaurantList
                                    : widget.isOrderAgain
                                        ? restController
                                            .orderAgainRestaurantList
                                        : restController.latestRestaurantList,
                          ),
                        )),
                      ],
                    ),
                  ))),
        ),
      );
    });
  }
}
