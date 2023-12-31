import '/data/model/response/product_model.dart';
import '/data/model/response/restaurant_model.dart';
import '/helper/responsive_helper.dart';
import '/util/dimensions.dart';
import '/view/base/no_data_screen.dart';
import '/view/base/product_shimmer.dart';
import '/view/base/product_widget.dart';
import '/view/base/web_restaurant_widget.dart';
import '/view/screens/home/theme1/restaurant_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductView extends StatelessWidget {
  final List<Product?>? products;
  final List<Restaurant?>? restaurants;
  final bool isRestaurant;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String? noDataText;
  final bool isCampaign;
  final bool inRestaurantPage;
  final bool showTheme1Restaurant;
  final bool? isWebRestaurant;
  const ProductView(
      {Key? key,
      required this.restaurants,
      required this.products,
      required this.isRestaurant,
      this.isScrollable = false,
      this.shimmerLength = 20,
      this.padding = const EdgeInsets.all(Dimensions.paddingSizeSmall),
      this.noDataText,
      this.isCampaign = false,
      this.inRestaurantPage = false,
      this.showTheme1Restaurant = false,
      this.isWebRestaurant = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isNull = true;
    int length = 0;
    if (isRestaurant) {
      isNull = restaurants == null;
      if (!isNull) {
        length = restaurants!.length;
      }
    } else {
      isNull = products == null;
      if (!isNull) {
        length = products!.length;
      }
    }

    return Column(
      children: [
        !isNull
            ? length > 0
                ? GridView.builder(
                    key: UniqueKey(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: Dimensions.paddingSizeLarge,
                      mainAxisExtent: MediaQuery.of(context).size.height * 0.3,
                      mainAxisSpacing: ResponsiveHelper.isDesktop(context) &&
                              !isWebRestaurant!
                          ? Dimensions.paddingSizeLarge
                          : isWebRestaurant!
                              ? Dimensions.paddingSizeLarge
                              : 0.01,
                      childAspectRatio: ResponsiveHelper.isDesktop(context) &&
                              !isWebRestaurant!
                          ? 3
                          : isWebRestaurant!
                              ? 1.5
                              : showTheme1Restaurant
                                  ? 1.9
                                  : 3.3,
                      crossAxisCount: ResponsiveHelper.isMobile(context) &&
                              !isWebRestaurant!
                          ? 1
                          : isWebRestaurant!
                              ? 2
                              : 2,
                    ),
                    physics: isScrollable
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    shrinkWrap: isScrollable ? false : true,
                    itemCount: length,
                    padding: padding,
                    itemBuilder: (context, index) {
                      return showTheme1Restaurant
                          ? RestaurantWidget(
                              restaurant: restaurants![index],
                              index: index,
                              inStore: inRestaurantPage)
                          : isWebRestaurant!
                              ? WebRestaurantWidget(
                                  restaurant: restaurants![index])
                              : SizedBox(
                                  height:
                                      !ResponsiveHelper.isDesktop(context) &&
                                              !isWebRestaurant!
                                          ? MediaQuery.of(context).size.height *
                                              0.3
                                          : null,
                                  child: ProductWidget(
                                    isRestaurant: isRestaurant,
                                    product:
                                        isRestaurant ? null : products![index],
                                    restaurant: isRestaurant
                                        ? restaurants![index]
                                        : null,
                                    index: index,
                                    length: length,
                                    isCampaign: isCampaign,
                                    inRestaurant: inRestaurantPage,
                                  ),
                                );
                    },
                  )
                : NoDataScreen(
                    isRestaurant: isRestaurant,
                    title: noDataText ??
                        (isRestaurant
                            ? 'no_restaurant_available'.tr
                            : 'no_food_available'.tr),
                  )
            : GridView.builder(
                key: UniqueKey(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: Dimensions.paddingSizeLarge,
                  mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                      ? Dimensions.paddingSizeLarge
                      : 0.01,
                  childAspectRatio:
                      ResponsiveHelper.isDesktop(context) && !isWebRestaurant!
                          ? 3
                          : isWebRestaurant!
                              ? 1.5
                              : showTheme1Restaurant
                                  ? 1.9
                                  : 3.3,
                  crossAxisCount:
                      ResponsiveHelper.isMobile(context) && !isWebRestaurant!
                          ? 1
                          : isWebRestaurant!
                              ? 4
                              : 3,
                ),
                physics: isScrollable
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                shrinkWrap: isScrollable ? false : true,
                itemCount: shimmerLength,
                padding: padding,
                itemBuilder: (context, index) {
                  return showTheme1Restaurant
                      ? RestaurantShimmer(isEnable: isNull)
                      : isWebRestaurant!
                          ? const WebRestaurantShimmer()
                          : ProductShimmer(
                              isEnabled: isNull,
                              isRestaurant: isRestaurant,
                              hasDivider: index != shimmerLength - 1);
                },
              ),
      ],
    );
  }
}
