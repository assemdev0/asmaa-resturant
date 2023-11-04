import '/controller/order_controller.dart';
import '/helper/price_converter.dart';
import '/helper/responsive_helper.dart';
import '/util/dimensions.dart';
import '/util/images.dart';
import '/util/styles.dart';
import '/view/screens/checkout/widget/payment_method_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentSection extends StatelessWidget {
  final bool isCashOnDeliveryActive;
  final bool isDigitalPaymentActive;
  final bool isWalletActive;
  final double total;
  final OrderController orderController;
  const PaymentSection({
    Key? key,
    required this.isCashOnDeliveryActive,
    required this.isDigitalPaymentActive,
    required this.isWalletActive,
    required this.total,
    required this.orderController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              spreadRadius: 1,
              offset: const Offset(1, 2))
        ],
      ),
      margin: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.isDesktop(context)
              ? 0
              : Dimensions.fontSizeDefault),
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
          vertical: Dimensions.paddingSizeDefault),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('choose_payment_method'.tr, style: robotoMedium),
          !ResponsiveHelper.isDesktop(context)
              ? InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (con) => PaymentMethodBottomSheet(
                        isCashOnDeliveryActive: isCashOnDeliveryActive,
                        isDigitalPaymentActive: isDigitalPaymentActive,
                        isWalletActive: isWalletActive,
                        totalPrice: total,
                      ),
                    );
                  },
                  child:
                      Image.asset(Images.paymentSelect, height: 24, width: 24),
                )
              : const SizedBox(),
        ]),
        const Divider(),
        InkWell(
          onTap: () {
            if (ResponsiveHelper.isDesktop(context)) {
              Get.dialog(Dialog(
                  backgroundColor: Colors.transparent,
                  child: PaymentMethodBottomSheet(
                    isCashOnDeliveryActive: isCashOnDeliveryActive,
                    isDigitalPaymentActive: isDigitalPaymentActive,
                    isWalletActive: isWalletActive,
                    totalPrice: total,
                  )));
            }
          },
          child: Row(children: [
            orderController.paymentMethodIndex != -1
                ? Image.asset(
                    orderController.paymentMethodIndex == 0
                        ? Images.cash
                        : orderController.paymentMethodIndex == 1
                            ? Images.wallet
                            : Images.digitalPayment,
                    width: 20,
                    height: 20,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  )
                : Icon(Icons.wallet_outlined,
                    size: 18, color: Theme.of(context).disabledColor),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
                child: Row(children: [
              Text(
                orderController.paymentMethodIndex == 0
                    ? 'cash_on_delivery'.tr
                    : orderController.paymentMethodIndex == 1
                        ? 'wallet_payment'.tr
                        : orderController.paymentMethodIndex == 2
                            ? 'digital_payment'.tr
                            : 'select_payment_method'.tr,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).disabledColor,
                ),
              ),
              orderController.paymentMethodIndex == -1
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: Dimensions.paddingSizeExtraSmall),
                      child: Icon(Icons.error,
                          size: 16, color: Theme.of(context).colorScheme.error),
                    )
                  : const SizedBox(),
            ])),
            !ResponsiveHelper.isDesktop(context)
                ? PriceConverter.convertAnimationPrice(
                    total,
                    textStyle: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).primaryColor),
                  )
                : const SizedBox(),
          ]),
        ),
        SizedBox(
            height: ResponsiveHelper.isDesktop(context)
                ? 0
                : Dimensions.paddingSizeSmall),
      ]),
    );
  }
}
