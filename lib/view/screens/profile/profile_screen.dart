import '/controller/auth_controller.dart';
import '/controller/splash_controller.dart';
import '/controller/theme_controller.dart';
import '/controller/user_controller.dart';
import '/helper/date_converter.dart';
import '/helper/price_converter.dart';
import '/helper/responsive_helper.dart';
import '/helper/route_helper.dart';
import '/util/app_constants.dart';
import '/util/dimensions.dart';
import '/util/images.dart';
import '/util/styles.dart';
import '/view/base/confirmation_dialog.dart';
import '/view/base/custom_image.dart';
import '/view/base/footer_view.dart';
import '/view/base/menu_drawer.dart';
import '/view/base/web_menu_bar.dart';
import '/view/screens/auth/widget/auth_dialog.dart';
import '/view/screens/profile/widget/profile_button.dart';
import '/view/screens/profile/widget/profile_card.dart';
import '/view/screens/profile/widget/web_profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall() {
    if (Get.find<AuthController>().isLoggedIn() &&
        Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    final bool showWalletCard =
        Get.find<SplashController>().configModel!.customerWalletStatus == 1 ||
            Get.find<SplashController>().configModel!.loyaltyPointStatus == 1;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: ResponsiveHelper.isDesktop(context)
          ? Theme.of(context).colorScheme.background
          : Theme.of(context).cardColor,
      body: GetBuilder<UserController>(builder: (userController) {
        return (isLoggedIn && userController.userInfoModel == null)
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: SingleChildScrollView(
                  child: FooterView(
                    minHeight: isLoggedIn
                        ? ResponsiveHelper.isDesktop(context)
                            ? 0.4
                            : 0.6
                        : 0.35,
                    child: (isLoggedIn && ResponsiveHelper.isDesktop(context))
                        ? const WebProfileWidget()
                        : Container(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.2),
                            width: Dimensions.webMaxWidth,
                            height: context.height,
                            child: Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions.paddingSizeLarge,
                                        vertical:
                                            Dimensions.paddingSizeExtraLarge),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          !ResponsiveHelper.isDesktop(context)
                                              ? IconButton(
                                                  onPressed: () => Get.back(),
                                                  icon: const Icon(
                                                      Icons.arrow_back_ios),
                                                )
                                              : const SizedBox(),
                                          Text('profile'.tr,
                                              style: robotoBold.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeLarge)),
                                          const SizedBox(width: 50),
                                        ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeExtraLarge,
                                        vertical:
                                            Dimensions.paddingSizeExtraLarge),
                                    child: Row(children: [
                                      ClipOval(
                                          child: CustomImage(
                                        placeholder: Images.guestIcon,
                                        image:
                                            '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}'
                                            '/${(userController.userInfoModel != null && isLoggedIn) ? userController.userInfoModel!.image : ''}',
                                        height: 70,
                                        width: 70,
                                        fit: BoxFit.cover,
                                      )),
                                      const SizedBox(
                                          width: Dimensions.paddingSizeDefault),
                                      Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                isLoggedIn
                                                    ? '${userController.userInfoModel!.fName} ${userController.userInfoModel!.lName}'
                                                    : 'guest_user'.tr,
                                                style: robotoBold.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraLarge),
                                              ),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeExtraSmall),
                                              isLoggedIn
                                                  ? Text(
                                                      '${'joined'.tr} ${DateConverter.containTAndZToUTCFormat(userController.userInfoModel!.createdAt!)}',
                                                      style: robotoMedium.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    )
                                                  : InkWell(
                                                      onTap: () async {
                                                        if (!ResponsiveHelper
                                                            .isDesktop(
                                                                context)) {
                                                          await Get.toNamed(RouteHelper
                                                              .getSignInRoute(Get
                                                                  .currentRoute));
                                                        } else {
                                                          Get.dialog(const Center(
                                                                  child: AuthDialog(
                                                                      exitFromApp:
                                                                          false,
                                                                      backFromThis:
                                                                          false)))
                                                              .then((value) {
                                                            initCall();
                                                            setState(() {});
                                                          });
                                                        }
                                                      },
                                                      child: Text(
                                                        'login_to_view_all_feature'
                                                            .tr,
                                                        style: robotoMedium.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                    ),
                                            ]),
                                      ),
                                      isLoggedIn
                                          ? InkWell(
                                              onTap: () => Get.toNamed(
                                                  RouteHelper
                                                      .getUpdateProfileRoute()),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.05),
                                                          blurRadius: 5,
                                                          spreadRadius: 1,
                                                          offset: const Offset(
                                                              3, 3))
                                                    ]),
                                                padding: const EdgeInsets.all(
                                                    Dimensions
                                                        .paddingSizeExtraSmall),
                                                child: const Icon(
                                                    Icons.edit_outlined,
                                                    size: 24,
                                                    color: Colors.blue),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () async {
                                                if (!ResponsiveHelper.isDesktop(
                                                    context)) {
                                                  await Get.toNamed(RouteHelper
                                                      .getSignInRoute(
                                                          Get.currentRoute));
                                                } else {
                                                  Get.dialog(const Center(
                                                          child: AuthDialog(
                                                              exitFromApp:
                                                                  false,
                                                              backFromThis:
                                                                  false)))
                                                      .then((value) {
                                                    initCall();
                                                    setState(() {});
                                                  });
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .radiusDefault),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    vertical: Dimensions
                                                        .paddingSizeSmall,
                                                    horizontal: Dimensions
                                                        .paddingSizeLarge),
                                                child: Text(
                                                  'login'.tr,
                                                  style: robotoMedium.copyWith(
                                                      color: Theme.of(context)
                                                          .cardColor),
                                                ),
                                              ),
                                            )
                                    ]),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(Dimensions
                                                    .radiusExtraLarge)),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeLarge,
                                          vertical:
                                              Dimensions.paddingSizeDefault),
                                      child: Column(children: [
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeLarge),
                                        (showWalletCard && isLoggedIn)
                                            ? Row(children: [
                                                Get.find<SplashController>()
                                                            .configModel!
                                                            .loyaltyPointStatus ==
                                                        1
                                                    ? Expanded(
                                                        child: ProfileCard(
                                                        image:
                                                            Images.loyaltyIcon,
                                                        data: userController
                                                                    .userInfoModel!
                                                                    .loyaltyPoint !=
                                                                null
                                                            ? userController
                                                                .userInfoModel!
                                                                .loyaltyPoint
                                                                .toString()
                                                            : '0',
                                                        title:
                                                            'loyalty_points'.tr,
                                                      ))
                                                    : const SizedBox(),
                                                SizedBox(
                                                    width: Get.find<SplashController>()
                                                                .configModel!
                                                                .loyaltyPointStatus ==
                                                            1
                                                        ? Dimensions
                                                            .paddingSizeSmall
                                                        : 0),
                                                isLoggedIn
                                                    ? Expanded(
                                                        child: ProfileCard(
                                                        image: Images
                                                            .shoppingBagIcon,
                                                        data: userController
                                                            .userInfoModel!
                                                            .orderCount
                                                            .toString(),
                                                        title: 'total_order'.tr,
                                                      ))
                                                    : const SizedBox(),
                                                SizedBox(
                                                    width: Get.find<SplashController>()
                                                                .configModel!
                                                                .customerWalletStatus ==
                                                            1
                                                        ? Dimensions
                                                            .paddingSizeSmall
                                                        : 0),
                                                Get.find<SplashController>()
                                                            .configModel!
                                                            .customerWalletStatus ==
                                                        1
                                                    ? Expanded(
                                                        child: ProfileCard(
                                                        image: Images
                                                            .walletProfile,
                                                        data: PriceConverter
                                                            .convertPrice(
                                                                userController
                                                                    .userInfoModel!
                                                                    .walletBalance),
                                                        title:
                                                            'wallet_balance'.tr,
                                                      ))
                                                    : const SizedBox(),
                                              ])
                                            : const SizedBox(),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeDefault),
                                        ProfileButton(
                                            icon: Icons.tonality_outlined,
                                            title: 'dark_mode'.tr,
                                            isButtonActive: Get.isDarkMode,
                                            onTap: () {
                                              Get.find<ThemeController>()
                                                  .toggleTheme();
                                            }),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),
                                        isLoggedIn
                                            ? GetBuilder<AuthController>(
                                                builder: (authController) {
                                                return ProfileButton(
                                                  icon: Icons.notifications,
                                                  title: 'notification'.tr,
                                                  isButtonActive: authController
                                                      .notification,
                                                  onTap: () {
                                                    authController
                                                        .setNotificationActive(
                                                            !authController
                                                                .notification);
                                                  },
                                                );
                                              })
                                            : const SizedBox(),
                                        SizedBox(
                                            height: isLoggedIn
                                                ? Dimensions.paddingSizeSmall
                                                : 0),
                                        isLoggedIn
                                            ? userController.userInfoModel!
                                                        .socialId ==
                                                    null
                                                ? ProfileButton(
                                                    icon: Icons.lock,
                                                    title: 'change_password'.tr,
                                                    onTap: () {
                                                      Get.toNamed(RouteHelper
                                                          .getResetPasswordRoute(
                                                              '',
                                                              '',
                                                              'password-change'));
                                                    })
                                                : const SizedBox()
                                            : const SizedBox(),
                                        SizedBox(
                                            height: isLoggedIn
                                                ? userController.userInfoModel!
                                                            .socialId ==
                                                        null
                                                    ? Dimensions
                                                        .paddingSizeSmall
                                                    : 0
                                                : 0),
                                        isLoggedIn
                                            ? ProfileButton(
                                                icon: Icons.delete,
                                                iconImage: Images.profileDelete,
                                                title: 'delete_account'.tr,
                                                onTap: () {
                                                  Get.dialog(
                                                      ConfirmationDialog(
                                                        isDelete: true,
                                                        icon:
                                                            Images.warningIcon,
                                                        title:
                                                            'are_you_sure'.tr,
                                                        titleColor:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .color,
                                                        description:
                                                            'it_will_remove_your_all_information'
                                                                .tr,
                                                        isLogOut: true,
                                                        onYesPressed: () =>
                                                            userController
                                                                .removeUser(),
                                                      ),
                                                      useSafeArea: false);
                                                },
                                              )
                                            : const SizedBox(),
                                        SizedBox(
                                            height: isLoggedIn
                                                ? Dimensions.paddingSizeLarge
                                                : 0),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('${'version'.tr}:',
                                                  style: robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeExtraSmall)),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeExtraSmall),
                                              Text(
                                                  AppConstants.appVersion
                                                      .toString(),
                                                  style: robotoMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeExtraSmall)),
                                            ]),
                                      ]),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              );
      }),
    );
  }
}
