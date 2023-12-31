import '/controller/order_controller.dart';
import '/helper/responsive_helper.dart';
import '/helper/route_helper.dart';
import '/util/dimensions.dart';
import '/util/images.dart';
import '/util/styles.dart';
import '/view/base/custom_button.dart';
import '/view/screens/auth/widget/auth_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotLoggedInScreen extends StatelessWidget {
  final Function(bool success) callBack;
  const NotLoggedInScreen({Key? key, required this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            Images.guest,
            width: MediaQuery.of(context).size.height * 0.25,
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            'sorry'.tr,
            style: robotoBold.copyWith(
                fontSize: MediaQuery.of(context).size.height * 0.023,
                color: Theme.of(context).primaryColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            'you_are_not_logged_in'.tr,
            style: robotoRegular.copyWith(
                fontSize: MediaQuery.of(context).size.height * 0.0175,
                color: Theme.of(context).disabledColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          SizedBox(
            width: 200,
            child: CustomButton(
                buttonText: 'login_to_continue'.tr,
                /*height: 40,*/ onPressed: () async {
                  if (!ResponsiveHelper.isDesktop(context)) {
                    await Get.toNamed(
                        RouteHelper.getSignInRoute(Get.currentRoute));
                  } else {
                    Get.dialog(const Center(
                            child: AuthDialog(
                                exitFromApp: false, backFromThis: false)))
                        .then((value) => callBack(true));
                    // Get.dialog(const SignInScreen(exitFromApp: false, backFromThis: true)).then((value) => callBack(true));
                  }
                  if (Get.find<OrderController>().showBottomSheet) {
                    Get.find<OrderController>().showRunningOrders();
                  }
                  callBack(true);
                }),
          ),
        ]),
      ),
    );
  }
}
