import '/controller/order_controller.dart';
import '/controller/restaurant_controller.dart';
import '/data/model/response/address_model.dart';
import '/util/dimensions.dart';
import '/view/screens/address/widget/address_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressDialogue extends StatelessWidget {
  final List<AddressModel?> addressList;
  final TextEditingController? streetNumberController;
  final TextEditingController? houseController;
  final TextEditingController? floorController;
  const AddressDialogue(
      {Key? key,
      required this.addressList,
      this.streetNumberController,
      this.houseController,
      this.floorController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        width: 500,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall,
                  horizontal: Dimensions.paddingSizeExtraSmall),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Text('select_a_address'.tr),
                  InkWell(
                      onTap: () => Get.back(), child: const Icon(Icons.clear)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: addressList.length,
                  itemBuilder: (context, index) {
                    return AddressWidget(
                        onTap: () {
                          Get.find<OrderController>().getDistanceInMeter(
                            LatLng(
                              double.parse(addressList[index]!.latitude!),
                              double.parse(addressList[index]!.longitude!),
                            ),
                            LatLng(
                              double.parse(Get.find<RestaurantController>()
                                  .restaurant!
                                  .latitude!),
                              double.parse(Get.find<RestaurantController>()
                                  .restaurant!
                                  .longitude!),
                            ),
                          );
                          Get.find<OrderController>().setAddressIndex(index);
                          streetNumberController!.text =
                              addressList[index]!.road ?? '';
                          houseController!.text =
                              addressList[index]!.house ?? '';
                          floorController!.text =
                              addressList[index]!.floor ?? '';

                          Get.back();
                        },
                        address: addressList[index],
                        fromAddress: false,
                        fromCheckout: true);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
