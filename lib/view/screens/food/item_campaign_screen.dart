import '/controller/campaign_controller.dart';
import '/util/dimensions.dart';
import '/view/base/custom_app_bar.dart';
import '/view/base/menu_drawer.dart';
import '/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemCampaignScreen extends StatefulWidget {
  const ItemCampaignScreen({Key? key}) : super(key: key);

  @override
  State<ItemCampaignScreen> createState() => _ItemCampaignScreenState();
}

class _ItemCampaignScreenState extends State<ItemCampaignScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<CampaignController>().getItemCampaignList(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'trending_food_offers'.tr),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: Scrollbar(
          child: SingleChildScrollView(
              child: Center(
                  child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: GetBuilder<CampaignController>(builder: (campController) {
          return ProductView(
            isRestaurant: false,
            products: campController.itemCampaignList,
            restaurants: null,
            isCampaign: true,
            noDataText: 'no_campaign_found'.tr,
          );
        }),
      )))),
    );
  }
}
