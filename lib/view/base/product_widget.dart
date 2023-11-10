import '/controller/auth_controller.dart';
import '/controller/cart_controller.dart';
import '/controller/product_controller.dart';
import '/controller/splash_controller.dart';
import '/controller/wishlist_controller.dart';
import '/data/model/response/cart_model.dart';
import '/data/model/response/config_model.dart';
import '/data/model/response/product_model.dart';
import '/data/model/response/restaurant_model.dart';
import '/helper/date_converter.dart';
import '/helper/price_converter.dart';
import '/helper/responsive_helper.dart';
import '/helper/route_helper.dart';
import '/util/dimensions.dart';
import '/util/images.dart';
import '/util/styles.dart';
import '/view/base/confirmation_dialog.dart';
import '/view/base/custom_image.dart';
import '/view/base/custom_snackbar.dart';
import '/view/base/discount_tag.dart';
import '/view/base/discount_tag_without_image.dart';
import '/view/base/not_available_widget.dart';
import '/view/base/product_bottom_sheet.dart';
import '/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductWidget extends StatelessWidget {
  final Product? product;
  final Restaurant? restaurant;
  final bool isRestaurant;
  final int index;
  final int? length;
  final bool inRestaurant;
  final bool isCampaign;
  final bool fromCartSuggestion;
  const ProductWidget(
      {Key? key,
      required this.product,
      required this.isRestaurant,
      required this.restaurant,
      required this.index,
      required this.length,
      this.inRestaurant = false,
      this.isCampaign = false,
      this.fromCartSuggestion = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseUrls? baseUrls = Get.find<SplashController>().configModel!.baseUrls;
    bool desktop = ResponsiveHelper.isDesktop(context);
    double? discount;
    String? discountType;
    bool isAvailable;
    String? image;
    double price = 0;
    double discountPrice = 0;
    if (isRestaurant) {
      image = restaurant!.logo;
      discount =
          restaurant!.discount != null ? restaurant!.discount!.discount : 0;
      discountType = restaurant!.discount != null
          ? restaurant!.discount!.discountType
          : 'percent';
      // bool _isClosedToday = Get.find<RestaurantController>().isRestaurantClosed(true, restaurant.active, restaurant.offDay);
      // _isAvailable = DateConverter.isAvailable(restaurant.openingTime, restaurant.closeingTime) && restaurant.active && !_isClosedToday;
      isAvailable = restaurant!.open == 1 && restaurant!.active!;
    } else {
      image = product!.image;
      discount = (product!.restaurantDiscount == 0 || isCampaign)
          ? product!.discount
          : product!.restaurantDiscount;
      discountType = (product!.restaurantDiscount == 0 || isCampaign)
          ? product!.discountType
          : 'percent';
      isAvailable = DateConverter.isAvailable(
          product!.availableTimeStarts, product!.availableTimeEnds);
      price = product!.price!;
      discountPrice =
          PriceConverter.convertWithDiscount(price, discount, discountType)!;
    }

    return InkWell(
      onTap: () {
        if (isRestaurant) {
          if (restaurant != null && restaurant!.restaurantStatus == 1) {
            Get.toNamed(RouteHelper.getRestaurantRoute(restaurant!.id),
                arguments: RestaurantScreen(restaurant: restaurant));
          } else if (restaurant!.restaurantStatus == 0) {
            showCustomSnackBar('restaurant_is_not_available'.tr);
          }
        } else {
          if (product!.restaurantStatus == 1) {
            ResponsiveHelper.isMobile(context)
                ? Get.bottomSheet(
                    ProductBottomSheet(
                        product: product,
                        inRestaurantPage: inRestaurant,
                        isCampaign: isCampaign),
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                  )
                : Get.dialog(
                    Dialog(
                        child: ProductBottomSheet(
                            product: product, inRestaurantPage: inRestaurant)),
                  );
          } else {
            showCustomSnackBar('item_is_not_available'.tr);
          }
        }
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: desktop ? 0 : Dimensions.paddingSizeSmall),
        child: Container(
          padding: desktop
              ? EdgeInsets.all(fromCartSuggestion
                  ? Dimensions.paddingSizeExtraSmall
                  : Dimensions.paddingSizeSmall)
              : const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeExtraSmall),
          margin: desktop
              ? null
              : const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(2, 5))
            ],
          ),
          // width: desktop ? 200 : double.maxFinite,
          // height: desktop ? 250 : 500,
          // MediaQuery.of(context).size.height * 0.35,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: desktop ? 0 : Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  ((image != null && image.isNotEmpty) || isRestaurant)
                      ? Stack(children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusDefault),
                            child: CustomImage(
                              image:
                                  '${isCampaign ? baseUrls!.campaignImageUrl : isRestaurant ? baseUrls!.restaurantImageUrl : baseUrls!.productImageUrl}'
                                  '/${isRestaurant ? restaurant!.logo : product!.image}',
                              height: desktop
                                  ? 250
                                  : length == null
                                      ? 230
                                      : 205,
                              width: desktop ? 200 : 160,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          DiscountTag(
                            discount: discount,
                            discountType: discountType,
                            freeDelivery:
                                isRestaurant ? restaurant!.freeDelivery : false,
                          ),
                          isAvailable
                              ? const SizedBox()
                              : NotAvailableWidget(isRestaurant: isRestaurant),
                        ])
                      : const SizedBox.shrink(),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  isRestaurant
                                      ? restaurant!.name!
                                      : product!.name!,
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeExtraSmall),
                                (!isRestaurant &&
                                        Get.find<SplashController>()
                                            .configModel!
                                            .toggleVegNonVeg!)
                                    ? Image.asset(
                                        product != null && product!.veg == 0
                                            ? Images.nonVegImage
                                            : Images.vegImage,
                                        height: 10,
                                        width: 10,
                                        fit: BoxFit.contain)
                                    : const SizedBox(),
                              ]),

                          SizedBox(
                              height: isRestaurant
                                  ? 0
                                  : Dimensions.paddingSizeExtraSmall),

                          Text(
                            isRestaurant ? '' : product!.restaurantName ?? '',
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Theme.of(context).disabledColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          isRestaurant
                              ? Row(children: [
                                  Icon(Icons.star,
                                      size: 16,
                                      color: Theme.of(context).primaryColor),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                      isRestaurant
                                          ? restaurant!.avgRating!
                                              .toStringAsFixed(1)
                                          : product!.avgRating!
                                              .toStringAsFixed(1),
                                      style: robotoMedium),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                      '(${isRestaurant ? restaurant!.ratingCount : product!.ratingCount})',
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color:
                                              Theme.of(context).disabledColor)),
                                ])
                              : const SizedBox(),

                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          // SizedBox(height: (desktop || isRestaurant) ? 5 : 0),

                          // !isRestaurant ? RatingBar(
                          //   rating: isRestaurant ? restaurant!.avgRating : product!.avgRating, size: desktop ? 15 : 12,
                          //   ratingCount: isRestaurant ? restaurant!.ratingCount : product!.ratingCount,
                          // ) : const SizedBox(),
                          !isRestaurant
                              ? Row(children: [
                                  Icon(Icons.star,
                                      size: 16,
                                      color: Theme.of(context).primaryColor),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text(product!.avgRating!.toStringAsFixed(1),
                                      style: robotoMedium),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text('(${product!.ratingCount})',
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color:
                                              Theme.of(context).disabledColor)),
                                ])
                              : const SizedBox(),

                          SizedBox(
                              height: (!isRestaurant && desktop)
                                  ? Dimensions.paddingSizeExtraSmall
                                  : 0),

                          isRestaurant
                              ? Row(
                                  children: [
                                    Text(
                                      'start_from'.tr,
                                      style: robotoRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraSmall,
                                          color:
                                              Theme.of(context).disabledColor),
                                    ),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    Text(
                                      PriceConverter.convertPrice(
                                          restaurant!.minimumOrder!),
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color),
                                    ),
                                  ],
                                )
                              : Row(children: [
                                  discount! > 0
                                      ? Text(
                                          PriceConverter.convertPrice(
                                              product!.price),
                                          textDirection: TextDirection.ltr,
                                          style: robotoMedium.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall,
                                            color:
                                                Theme.of(context).disabledColor,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        )
                                      : const SizedBox(),
                                  SizedBox(
                                      width: discount > 0
                                          ? Dimensions.paddingSizeExtraSmall
                                          : 0),
                                  Text(
                                    PriceConverter.convertPrice(product!.price,
                                        discount: discount,
                                        discountType: discountType),
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context).primaryColor),
                                    textDirection: TextDirection.ltr,
                                  ),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  (image != null && image.isNotEmpty)
                                      ? const SizedBox.shrink()
                                      : DiscountTagWithoutImage(
                                          discount: discount,
                                          discountType: discountType,
                                          freeDelivery: isRestaurant
                                              ? restaurant!.freeDelivery
                                              : false),
                                ]),
                        ]),
                  ),
                  Column(
                      mainAxisAlignment: isRestaurant
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        fromCartSuggestion
                            ? const SizedBox()
                            : GetBuilder<WishListController>(
                                builder: (wishController) {
                                bool isWished = isRestaurant
                                    ? wishController.wishRestIdList
                                        .contains(restaurant!.id)
                                    : wishController.wishProductIdList
                                        .contains(product!.id);
                                return InkWell(
                                  onTap: () {
                                    if (Get.find<AuthController>()
                                        .isLoggedIn()) {
                                      isWished
                                          ? wishController.removeFromWishList(
                                              isRestaurant
                                                  ? restaurant!.id
                                                  : product!.id,
                                              isRestaurant)
                                          : wishController.addToWishList(
                                              product,
                                              restaurant,
                                              isRestaurant);
                                    } else {
                                      showCustomSnackBar(
                                          'you_are_not_logged_in'.tr);
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: desktop
                                            ? Dimensions.paddingSizeSmall
                                            : 0),
                                    child: Icon(
                                      Icons.favorite,
                                      size: desktop ? 30 : 25,
                                      color: isWished
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.2),
                                    ),
                                  ),
                                );
                              }),
                        !isRestaurant
                            ? GetBuilder<CartController>(
                                builder: (cartController) {
                                int cartQty =
                                    cartController.cartQuantity(product!.id!);
                                int cartIndex = cartController.isExistInCart(
                                    product!.id, null);
                                CartModel cartModel = CartModel(
                                  price,
                                  discountPrice,
                                  (price - discountPrice),
                                  1,
                                  [],
                                  [],
                                  false,
                                  product,
                                  [],
                                );
                                return cartQty != 0
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusExtraLarge),
                                        ),
                                        child: Row(children: [
                                          InkWell(
                                            onTap: () {
                                              if (cartController
                                                      .cartList[cartIndex]
                                                      .quantity! >
                                                  1) {
                                                cartController.setQuantity(
                                                    false, cartModel,
                                                    cartIndex: cartIndex);
                                              } else {
                                                cartController
                                                    .removeFromCart(cartIndex);
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              padding: const EdgeInsets.all(
                                                  Dimensions
                                                      .paddingSizeExtraSmall),
                                              child: Icon(
                                                Icons.remove,
                                                size: 16,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeSmall),
                                            child: Text(
                                              cartQty.toString(),
                                              style: robotoMedium.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  color: Theme.of(context)
                                                      .cardColor),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              cartController.setQuantity(
                                                  true, cartModel,
                                                  cartIndex: cartIndex);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              padding: const EdgeInsets.all(
                                                  Dimensions
                                                      .paddingSizeExtraSmall),
                                              child: Icon(
                                                Icons.add,
                                                size: 16,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          if (product!.variations == null ||
                                              (product!.variations != null &&
                                                  product!
                                                      .variations!.isEmpty)) {
                                            Get.find<ProductController>()
                                                .setExistInCart(product!);

                                            if (Get.find<CartController>()
                                                .existAnotherRestaurantProduct(
                                                    cartModel.product!
                                                        .restaurantId)) {
                                              Get.dialog(
                                                  ConfirmationDialog(
                                                    icon: Images.warning,
                                                    title:
                                                        'are_you_sure_to_reset'
                                                            .tr,
                                                    description:
                                                        'if_you_continue'.tr,
                                                    onYesPressed: () {
                                                      Get.back();
                                                      Get.find<CartController>()
                                                          .removeAllAndAddToCart(
                                                              cartModel);
                                                      _showCartSnackBar();
                                                    },
                                                  ),
                                                  barrierDismissible: false);
                                            } else {
                                              Get.find<CartController>()
                                                  .addToCart(
                                                      cartModel,
                                                      Get.find<
                                                              ProductController>()
                                                          .cartIndex);
                                              _showCartSnackBar();
                                            }
                                          } else {
                                            ResponsiveHelper.isMobile(context)
                                                ? Get.bottomSheet(
                                                    ProductBottomSheet(
                                                        product: product,
                                                        isCampaign: false),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    isScrollControlled: true,
                                                  )
                                                : Get.dialog(
                                                    Dialog(
                                                        child:
                                                            ProductBottomSheet(
                                                                product:
                                                                    product,
                                                                isCampaign:
                                                                    false)),
                                                  );
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  spreadRadius: 1,
                                                  blurRadius: 10,
                                                  offset: const Offset(2, 5))
                                            ],
                                          ),
                                          child: Icon(Icons.add,
                                              size: desktop ? 30 : 25,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      );
                              })
                            : const SizedBox(),
                      ]),
                ]),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showCartSnackBar() {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.horizontal,
      margin: ResponsiveHelper.isDesktop(Get.context)
          ? EdgeInsets.only(
              right: Get.context!.width * 0.7,
              left: Dimensions.paddingSizeSmall,
              bottom: Dimensions.paddingSizeSmall,
            )
          : const EdgeInsets.all(Dimensions.paddingSizeSmall),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green,
      action: SnackBarAction(
          label: 'view_cart'.tr,
          textColor: Colors.white,
          onPressed: () {
            Get.toNamed(RouteHelper.getCartRoute());
          }),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      content: Text(
        'item_added_to_cart'.tr,
        style: robotoMedium.copyWith(color: Colors.white),
      ),
    ));
  }
}
