import '/controller/cuisine_controller.dart';
import '/helper/responsive_helper.dart';
import '/util/dimensions.dart';
import '/view/base/custom_app_bar.dart';
import '/view/base/footer_view.dart';
import '/view/base/menu_drawer.dart';
import '/view/base/paginated_list_view.dart';
import '/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CuisineRestaurantScreen extends StatefulWidget {
  final int cuisineId;
  final String? name;
  const CuisineRestaurantScreen(
      {Key? key, required this.cuisineId, required this.name})
      : super(key: key);

  @override
  State<CuisineRestaurantScreen> createState() =>
      _CuisineRestaurantScreenState();
}

class _CuisineRestaurantScreenState extends State<CuisineRestaurantScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<CuisineController>().initialize();
    Get.find<CuisineController>()
        .getCuisineRestaurantList(widget.cuisineId, 1, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '${widget.name!} ${'cuisines'.tr}'),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: Scrollbar(
        child: SingleChildScrollView(
          child: FooterView(
            child: Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child:
                    GetBuilder<CuisineController>(builder: (cuisineController) {
                  if (cuisineController.cuisineRestaurantsModel != null) {}
                  return PaginatedListView(
                    scrollController: _scrollController,
                    totalSize: cuisineController.cuisineRestaurantsModel != null
                        ? cuisineController.cuisineRestaurantsModel!.totalSize
                        : null,
                    offset: cuisineController.cuisineRestaurantsModel != null
                        ? int.parse(
                            cuisineController.cuisineRestaurantsModel!.offset!)
                        : null,
                    onPaginate: (int? offset) async =>
                        await cuisineController.getCuisineRestaurantList(
                            widget.cuisineId, offset!, false),
                    productView: ProductView(
                      isRestaurant: true,
                      products: null,
                      restaurants:
                          cuisineController.cuisineRestaurantsModel != null
                              ? cuisineController
                                  .cuisineRestaurantsModel!.restaurants
                              : null,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.isDesktop(context)
                            ? Dimensions.paddingSizeExtraSmall
                            : Dimensions.paddingSizeSmall,
                        vertical: ResponsiveHelper.isDesktop(context)
                            ? Dimensions.paddingSizeExtraSmall
                            : 0,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
