import 'package:flutter/material.dart';
import 'package:sun3ah_provider/components/price_widget.dart';
import 'package:sun3ah_provider/components/view_all_label_component.dart';
import 'package:sun3ah_provider/main.dart';
import 'package:sun3ah_provider/models/Package_response.dart';
import 'package:sun3ah_provider/models/booking_detail_response.dart';
import 'package:sun3ah_provider/models/booking_list_response.dart';
import 'package:sun3ah_provider/models/service_model.dart';
import 'package:sun3ah_provider/utils/common.dart';
import 'package:sun3ah_provider/utils/configs.dart';
import 'package:sun3ah_provider/utils/constant.dart';
import 'package:sun3ah_provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class PriceCommonWidget extends StatelessWidget {
  final BookingData bookingDetail;
  final ServiceData serviceDetail;
  final CouponData? couponData;
  final List<TaxData> taxes;
  final PackageData? bookingPackage;

  const PriceCommonWidget({
    Key? key,
    required this.bookingDetail,
    required this.serviceDetail,
    required this.taxes,
    required this.couponData,
    required this.bookingPackage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //price details
        ViewAllLabel(
          label: languages!.lblPriceDetail,
          list: [],
        ),
        8.height,
        if (bookingPackage != null)
          Container(
            padding: EdgeInsets.all(16),
            width: context.width(),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(languages!.lblTotalAmount, style: secondaryTextStyle(size: 16)).expand(),
                    PriceWidget(price: bookingDetail.amount.validate(), color: primaryColor, size: 18),
                  ],
                ),
              ],
            ),
          )
        else
          Container(
            padding: EdgeInsets.all(16),
            width: context.width(),
            decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: radius()),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(languages!.hintPrice, style: secondaryTextStyle(size: 16)).expand(),
                    PriceWidget(price: bookingDetail.amount.validate(), color: textPrimaryColorGlobal, isBoldText: true, size: 18).flexible(),
                  ],
                ),
                if (bookingDetail.type == SERVICE_TYPE_FIXED)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(height: 26),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(languages!.lblSubTotal, style: secondaryTextStyle(size: 16)),
                          8.width,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${appStore.currencySymbol}${bookingDetail.amount.validate().toStringAsFixed(DECIMAL_POINT)} * ${bookingDetail.quantity != 0 ? bookingDetail.quantity : 1}',
                                style: secondaryTextStyle(size: 14),
                                textAlign: TextAlign.right,
                              ).flexible(),
                              4.width,
                              Text(
                                '${appStore.currencySymbol}${(bookingDetail.amount.validate() * (bookingDetail.quantity != 0 ? bookingDetail.quantity.validate() : 1)).toStringAsFixed(DECIMAL_POINT)}',
                                style: boldTextStyle(size: 18),
                                textAlign: TextAlign.right,
                              ).flexible(),
                            ],
                          ).expand(),
                        ],
                      ),
                    ],
                  ),
                if (taxes.isNotEmpty) Divider(height: 26),
                if (taxes.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(languages!.lblTax, style: secondaryTextStyle(size: 16)).expand(),
                      PriceWidget(price: serviceDetail.taxAmount.validate(), color: Colors.red, isBoldText: true, size: 18).flexible(),
                    ],
                  ),
                if (serviceDetail.discountPrice.validate() != 0 && serviceDetail.discount.validate() != 0)
                  Column(
                    children: [
                      Divider(height: 26),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(languages!.hintDiscount, style: secondaryTextStyle(size: 16)),
                              Text(
                                " (${serviceDetail.discount.validate()}% ${languages!.lblOff})",
                                style: boldTextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                          PriceWidget(
                            price: serviceDetail.discountPrice.validate(),
                            size: 18,
                            color: Colors.green,
                            isBoldText: true,
                            isDiscountedPrice: true,
                          ).flexible(),
                        ],
                      ),
                    ],
                  ),
                if (couponData != null) Divider(height: 26),
                if (couponData != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(languages!.lblCoupon, style: secondaryTextStyle(size: 16)),
                          Text(" (${couponData!.code})", style: secondaryTextStyle(size: 16, color: primaryColor)),
                        ],
                      ),
                      PriceWidget(
                        price: serviceDetail.couponDiscountAmount.validate(),
                        size: 18,
                        color: Colors.green,
                        isBoldText: true,
                      ).flexible(),
                    ],
                  ),
                if (bookingDetail.extraCharges.validate().isNotEmpty) Divider(height: 26),
                if (bookingDetail.extraCharges.validate().isNotEmpty)
                  Row(
                    children: [
                      Text(languages!.lblTotalCharges, style: secondaryTextStyle(size: 16)).expand(),
                      PriceWidget(price: bookingDetail.extraCharges.sumByDouble((e) => e.total.validate()), color: textPrimaryColorGlobal, size: 18),
                    ],
                  ),
                Divider(height: 26),
                Row(
                  children: [
                    Text(languages!.lblTotalAmount, style: secondaryTextStyle(size: 16)).expand(),
                    if (bookingDetail.type == SERVICE_TYPE_HOURLY) Text('(${appStore.currencySymbol}${bookingDetail.price}/hr) ', style: secondaryTextStyle()),
                    PriceWidget(price: getTotalValue, color: primaryColor, size: 18),
                  ],
                ),
                if (bookingDetail.type == SERVICE_TYPE_HOURLY && bookingDetail.status == BookingStatusKeys.complete)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        6.height,
                        Text(
                          "${languages!.lblOnBasisOf} ${calculateTimer(bookingDetail.durationDiff.validate().toInt())} ${getMinHour(durationDiff: bookingDetail.durationDiff.validate())}",
                          style: secondaryTextStyle(),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )
      ],
    );
  }

  num get getTotalValue {
    num totalAmount = calculateTotalAmount(
      serviceDiscountPercent: serviceDetail.discount.validate(),
      qty: bookingDetail.quantity.validate(value: 1).toInt(),
      detail: serviceDetail,
      servicePrice: bookingDetail.amount.validate(),
      taxes: taxes,
      couponData: couponData,
      extraCharges: bookingDetail.extraCharges.validate(),
    );

    if (bookingDetail.isHourlyService && bookingDetail.status == BookingStatusKeys.complete) {
      return calculateTotalAmount(
        serviceDiscountPercent: serviceDetail.discount.validate(),
        qty: bookingDetail.quantity.validate(value: 1).toInt(),
        detail: serviceDetail,
        servicePrice: getHourlyPrice(
          price: bookingDetail.amount.validate(),
          secTime: bookingDetail.durationDiff.validate().toInt(),
          date: bookingDetail.date.validate(),
        ),
        taxes: taxes,
        couponData: couponData,
        extraCharges: bookingDetail.extraCharges.validate(),
      );
    }

    return totalAmount;
  }

  String getMinHour({required String durationDiff}) {
    String totalTime = calculateTimer(durationDiff.toInt());
    List<String> totalHours = totalTime.split(":");
    if (totalHours.first == "00") {
      return "min";
    } else {
      return "hour";
    }
  }
}
