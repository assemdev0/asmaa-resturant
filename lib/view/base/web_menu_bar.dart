import '/controller/auth_controller.dart';
import '/controller/cart_controller.dart';
import '/controller/localization_controller.dart';
import '/controller/location_controller.dart';
import '/controller/theme_controller.dart';
import '/helper/route_helper.dart';
import '/util/app_constants.dart';
import '/util/dimensions.dart';
import '/util/images.dart';
import '/util/styles.dart';
import '/view/base/hover/text_hover.dart';
import '/view/screens/auth/widget/auth_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebMenuBar extends StatelessWidget implements PreferredSizeWidget {
  const WebMenuBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.webMaxWidth,
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: Row(children: [
            InkWell(
              onTap: () => Get.toNamed(RouteHelper.getInitialRoute()),
              child: Image.asset(Images.logo, height: 50, width: 50),
            ),
            Get.find<LocationController>().getUserAddress() != null
                ? Expanded(
                    child: InkWell(
                    onTap: () => Get.find<LocationController>()
                        .navigateToLocationScreen('home'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall),
                      child: GetBuilder<LocationController>(
                          builder: (locationController) {
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  locationController
                                              .getUserAddress()!
                                              .addressType ==
                                          'home'
                                      ? Icons.home_filled
                                      : locationController
                                                  .getUserAddress()!
                                                  .addressType ==
                                              'office'
                                          ? Icons.work
                                          : Icons.location_on,
                                  size: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeExtraSmall),
                                Flexible(
                                  child: Text(
                                    locationController
                                        .getUserAddress()!
                                        .addressType!
                                        .tr,
                                    style: robotoMedium.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeSmall,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    locationController
                                        .getUserAddress()!
                                        .address!,
                                    style: robotoRegular.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                      fontSize: Dimensions.fontSizeSmall,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_down,
                                    color: Theme.of(context).primaryColor),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                  ))
                : const Expanded(child: SizedBox()),
            const SizedBox(width: 20),
            Row(
              children: [
                MenuButton(
                    title: 'home'.tr,
                    onTap: () => Get.toNamed(RouteHelper.getInitialRoute())),
                const SizedBox(width: 20),
                MenuButton(
                    title: 'categories'.tr,
                    onTap: () => Get.toNamed(RouteHelper.getCategoryRoute())),
                const SizedBox(width: 20),
                MenuButton(
                    title: 'cuisines'.tr,
                    onTap: () => Get.toNamed(RouteHelper.getCuisineRoute())),
                const SizedBox(width: 20),
                MenuButton(
                    title: 'restaurants'.tr,
                    onTap: () => Get.toNamed(
                        RouteHelper.getAllRestaurantRoute('popular'))),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(width: 20),
            GetBuilder<AuthController>(builder: (authController) {
              return InkWell(
                onTap: () {
                  if (authController.isLoggedIn()) {
                    Get.toNamed(RouteHelper.getProfileRoute());
                  } else {
                    Get.dialog(const Center(
                        child: AuthDialog(
                            exitFromApp: false, backFromThis: false)));
                  }
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Row(children: [
                    Icon(
                        authController.isLoggedIn()
                            ? Icons.person_pin_rounded
                            : Icons.lock_outline,
                        size: 18,
                        color: Get.find<ThemeController>().darkTheme
                            ? Colors.white
                            : Colors.black),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Text(
                        authController.isLoggedIn()
                            ? 'profile'.tr
                            : 'sign_in'.tr,
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.w100)),
                  ]),
                ),
              );
            }),
            GetBuilder<LocalizationController>(
                builder: (localizationController) {
              int index0 = 0;
              List<DropdownMenuItem<int>> languageList = [];
              for (int index = 0;
                  index < AppConstants.joinDropdown.length;
                  index++) {
                languageList.add(DropdownMenuItem(
                  value: index,
                  child: TextHover(builder: (hovered) {
                    return Row(
                      children: [
                        index == 0
                            ? Icon(Icons.perm_identity,
                                color: Get.find<ThemeController>().darkTheme
                                    ? Colors.white
                                    : Colors.black)
                            : const SizedBox(),
                        index == 0
                            ? const SizedBox(width: Dimensions.paddingSizeSmall)
                            : const SizedBox(),
                        Text(AppConstants.joinDropdown[index].tr,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                fontWeight: FontWeight.w100,
                                color: Get.find<ThemeController>().darkTheme
                                    ? Colors.white
                                    : Colors.black)),
                        index == 0
                            ? const SizedBox(width: Dimensions.paddingSizeSmall)
                            : const SizedBox(),
                        index == 0
                            ? Icon(Icons.keyboard_arrow_down,
                                color: Get.find<ThemeController>().darkTheme
                                    ? Colors.white
                                    : Colors.black)
                            : const SizedBox(),
                      ],
                    );
                  }),
                ));
              }
              return SizedBox(
                width: 170,
                child: DropdownButton<int>(
                  value: index0,
                  items: languageList,
                  dropdownColor: Theme.of(context).cardColor,
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.white, size: 0.0),
                  elevation: 0,
                  iconSize: 30,
                  underline: const SizedBox(),
                  onChanged: (int? index) {
                    if (index == 1) {
                      Get.toNamed(RouteHelper.getRestaurantRegistrationRoute());
                    } else if (index == 2) {
                      Get.toNamed(
                          RouteHelper.getDeliverymanRegistrationRoute());
                    }
                    //localizationController.setLanguage(Locale(AppConstants.languages[index].languageCode, AppConstants.languages[index].countryCode));
                  },
                ),
              );
            }),
            MenuIconButton(
                icon: Icons.notifications,
                onTap: () => Get.toNamed(RouteHelper.getNotificationRoute())),
            const SizedBox(width: 20),
            MenuIconButton(
                icon: Icons.search,
                onTap: () => Get.toNamed(RouteHelper.getSearchRoute())),
            const SizedBox(width: 20),
            MenuIconButton(
                icon: Icons.shopping_cart,
                isCart: true,
                onTap: () => Get.toNamed(RouteHelper.getCartRoute())),
            const SizedBox(width: 20),
            MenuIconButton(
                icon: Icons.menu,
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                  // Get.bottomSheet(const MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true);
                }),
          ]),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(Dimensions.webMaxWidth, 70);
}

class MenuButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const MenuButton({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextHover(builder: (hovered) {
      return InkWell(
        onTap: onTap as void Function()?,
        child: Text(title,
            style: robotoRegular.copyWith(
                color: hovered ? Theme.of(context).primaryColor : null)),
      );
    });
  }
}

class MenuIconButton extends StatelessWidget {
  final IconData icon;
  final bool isCart;
  final Function onTap;
  const MenuIconButton(
      {Key? key, required this.icon, this.isCart = false, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextHover(builder: (hovered) {
      return IconButton(
        onPressed: onTap as void Function()?,
        icon: GetBuilder<CartController>(builder: (cartController) {
          return Stack(clipBehavior: Clip.none, children: [
            Icon(
              icon,
              color: hovered
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.bodyLarge!.color,
            ),
            (isCart && cartController.cartList.isNotEmpty)
                ? Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      height: 15,
                      width: 15,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor),
                      child: Text(
                        cartController.cartList.length.toString(),
                        style: robotoRegular.copyWith(
                            fontSize: 12, color: Theme.of(context).cardColor),
                      ),
                    ),
                  )
                : const SizedBox()
          ]);
        }),
      );
    });
  }
}
