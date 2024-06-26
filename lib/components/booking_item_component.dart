import 'package:flutter/material.dart';
import 'package:sun3ah_provider/components/cached_image_widget.dart';
import 'package:sun3ah_provider/components/price_widget.dart';
import 'package:sun3ah_provider/main.dart';
import 'package:sun3ah_provider/models/booking_list_response.dart';
import 'package:sun3ah_provider/networks/rest_apis.dart';
import 'package:sun3ah_provider/provider/components/assign_handyman_screen.dart';
import 'package:sun3ah_provider/provider/components/booking_summary_dialog.dart';
import 'package:sun3ah_provider/screens/booking_detail_screen.dart';
import 'package:sun3ah_provider/utils/common.dart';
import 'package:sun3ah_provider/utils/configs.dart';
import 'package:sun3ah_provider/utils/constant.dart';
import 'package:sun3ah_provider/utils/extensions/color_extension.dart';
import 'package:sun3ah_provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingItemComponent extends StatefulWidget {
  final String? status;
  final BookingData bookingData;
  final int? index;
  final bool showDescription;

  BookingItemComponent({this.status, required this.bookingData, this.index, this.showDescription = true});

  @override
  BookingItemComponentState createState() => BookingItemComponentState();
}

class BookingItemComponentState extends State<BookingItemComponent> {
  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    //
  }

  String buildTimeWidget({required BookingData bookingDetail}) {
    if (bookingDetail.bookingSlot == null) {
      return formatDate(bookingDetail.date.validate(), format: DATE_FORMAT_3);
    }
    return TimeOfDay(hour: bookingDetail.bookingSlot.validate().splitBefore(':').split(":").first.toInt(), minute: bookingDetail.bookingSlot.validate().splitBefore(':').split(":").last.toInt()).format(context);
  }

  Future<void> updateBooking(int bookingId, String updatedStatus, int index) async {
    appStore.setLoading(true);
    Map request = {
      CommonKeys.id: bookingId,
      BookingUpdateKeys.status: updatedStatus,
    };
    await bookingUpdate(request).then((res) async {
      LiveStream().emit(LIVESTREAM_UPDATE_BOOKINGS);
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  Future<void> confirmationRequestDialog(BuildContext context, int index, String status) async {
    showConfirmDialogCustom(
      context,
      positiveText: languages!.lblYes,
      negativeText: languages!.lblNo,
      primaryColor: status == BookingStatusKeys.rejected ? Colors.redAccent : primaryColor,
      onAccept: (context) async {
        LiveStream().emit(LIVESTREAM_UPDATE_BOOKINGS);
        updateBooking(widget.bookingData.id.validate(), status, index);
      },
      title: languages!.confirmationRequestTxt,
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 16),
      width: context.width(),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: context.scaffoldBackgroundColor,
        border: Border.all(color: context.dividerColor, width: 1.0),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.bookingData.isPackageBooking && widget.bookingData.bookingPackage != null)
                CachedImageWidget(
                  url: widget.bookingData.bookingPackage!.imageAttachments.validate().isNotEmpty ? widget.bookingData.bookingPackage!.imageAttachments.validate().first.validate() : "",
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  radius: defaultRadius,
                )
              else
                CachedImageWidget(
                  url: widget.bookingData.imageAttachments.validate().isNotEmpty ? widget.bookingData.imageAttachments!.first.validate() : '',
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                  radius: defaultRadius,
                ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.bookingData.status.validate().getPaymentStatusBackgroundColor.withOpacity(0.1),
                              borderRadius: radius(8),
                            ),
                            child: Text(
                              widget.bookingData.statusLabel.validate(),
                              style: boldTextStyle(color: widget.bookingData.status.validate().getPaymentStatusBackgroundColor, size: 12),
                            ),
                          ),
                          if (widget.bookingData.isPostJob)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              margin: EdgeInsets.only(left: 4),
                              decoration: BoxDecoration(
                                color: context.primaryColor.withOpacity(0.1),
                                borderRadius: radius(8),
                              ),
                              child: Text(
                                languages!.postJob,
                                style: boldTextStyle(color: context.primaryColor, size: 12),
                              ),
                            ),
                          if (widget.bookingData.isPackageBooking)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              margin: EdgeInsets.only(left: 4),
                              decoration: BoxDecoration(
                                color: context.primaryColor.withOpacity(0.1),
                                borderRadius: radius(8),
                              ),
                              child: Text(
                                languages!.package,
                                style: boldTextStyle(color: context.primaryColor, size: 12),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        '#${widget.bookingData.id.validate()}',
                        style: boldTextStyle(color: context.primaryColor, size: 16),
                      ),
                    ],
                  ),
                  8.height,
                  Marquee(
                    child: Text(widget.bookingData.isPackageBooking ? '${widget.bookingData.bookingPackage!.name.validate()}' : '${widget.bookingData.serviceName.validate()}',
                        style: boldTextStyle(size: 16), overflow: TextOverflow.ellipsis, maxLines: 1),
                  ),
                  8.height,
                  if (widget.bookingData.bookingPackage != null)
                    PriceWidget(
                      price: widget.bookingData.amount.validate(),
                      color: primaryColor,
                      size: 18,
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.bookingData.bookingType == BOOKING_TYPE_SERVICE)
                          PriceWidget(
                            isFreeService: widget.bookingData.isFreeService,
                            price: widget.bookingData.isHourlyService
                                ? widget.bookingData.totalAmountWithExtraCharges.validate()
                                : calculateTotalAmount(
                                    servicePrice: widget.bookingData.amount.validate(),
                                    qty: widget.bookingData.quantity.validate(),
                                    couponData: widget.bookingData.couponData != null ? widget.bookingData.couponData : null,
                                    taxes: widget.bookingData.taxes.validate(),
                                    serviceDiscountPercent: widget.bookingData.discount.validate(),
                                    extraCharges: widget.bookingData.extraCharges,
                                  ),
                            color: primaryColor,
                            //isHourlyService: widget.bookingData.isHourlyService,
                            size: 18,
                          )
                        else
                          PriceWidget(price: widget.bookingData.totalAmount.validate()),
                        if (widget.bookingData.isHourlyService) Text(languages!.lblHourly, style: secondaryTextStyle()).paddingSymmetric(horizontal: 4),
                        if (!widget.bookingData.isHourlyService) 4.width,
                        if (widget.bookingData.discount != null && widget.bookingData.discount != 0)
                          Row(
                            children: [
                              Text('(${widget.bookingData.discount.validate()}%', style: boldTextStyle(size: 14, color: Colors.green)),
                              Text(' ${languages!.lblOff})', style: boldTextStyle(size: 14, color: Colors.green)),
                            ],
                          ),
                      ],
                    ),
                ],
              ).expand(),
            ],
          ).paddingAll(8),
          if (widget.showDescription)
            Container(
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: context.cardColor,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              margin: EdgeInsets.all(8),
              //decoration: cardDecoration(context),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(languages!.lblAddress, style: secondaryTextStyle()),
                      8.width,
                      Marquee(
                        child: Text(
                          widget.bookingData.address != null ? widget.bookingData.address.validate() : languages!.notAvailable,
                          style: boldTextStyle(size: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ).flexible(),
                    ],
                  ).paddingAll(8),
                  Divider(height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${languages!.lblDate} & ${languages!.lblTime}', style: secondaryTextStyle()),
                      8.width,
                      Text(
                        "${formatDate(widget.bookingData.date.validate(), format: DATE_FORMAT_2)} At ${buildTimeWidget(bookingDetail: widget.bookingData)}",
                        style: boldTextStyle(size: 14),
                        maxLines: 2,
                        textAlign: TextAlign.right,
                      ).expand(),
                    ],
                  ).paddingAll(8),
                  if (widget.bookingData.customerName.validate().isNotEmpty)
                    Column(
                      children: [
                        Divider(height: 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(languages!.customer, style: secondaryTextStyle()),
                            8.width,
                            Text(widget.bookingData.customerName.validate(), style: boldTextStyle(size: 14), textAlign: TextAlign.right).flexible(),
                          ],
                        ).paddingAll(8),
                      ],
                    ),
                  /* if (!isUserTypeHandyman && widget.bookingData.providerName.validate().isNotEmpty)
                  Column(
                    children: [
                      Divider(height: 0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(languages!.provider, style: secondaryTextStyle()),
                          8.width,
                          Text(widget.bookingData.providerName.validate(), style: boldTextStyle(size: 14), textAlign: TextAlign.right).flexible(),
                        ],
                      ).paddingAll(8),
                    ],
                  ),*/
                  if (widget.bookingData.handyman.validate().isNotEmpty && isUserTypeProvider)
                    Column(
                      children: [
                        Divider(height: 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(languages!.handyman, style: secondaryTextStyle()),
                            Text(widget.bookingData.handyman.validate().first.handyman!.displayName.validate(), style: boldTextStyle(size: 14)).flexible(),
                          ],
                        ).paddingAll(8),
                      ],
                    ),
                  if (widget.bookingData.paymentStatus != null && widget.bookingData.status == BookingStatusKeys.complete)
                    Column(
                      children: [
                        Divider(height: 0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(languages!.paymentStatus, style: secondaryTextStyle()).expand(),
                            Text(
                              buildPaymentStatusWithMethod(widget.bookingData.paymentStatus.validate(), widget.bookingData.paymentMethod.validate().capitalizeFirstLetter()),
                              style: boldTextStyle(size: 14, color: widget.bookingData.paymentStatus.validate() == PAID ? Colors.green : Colors.red),
                            ),
                          ],
                        ).paddingAll(8),
                      ],
                    ),
                  if (isUserTypeProvider && widget.bookingData.status == BookingStatusKeys.pending || (isUserTypeHandyman && widget.bookingData.status == BookingStatusKeys.accept))
                    Row(
                      children: [
                        if (isUserTypeProvider)
                          Row(
                            children: [
                              AppButton(
                                child: Text(languages!.accept, style: boldTextStyle(color: white)),
                                width: context.width(),
                                color: primaryColor,
                                elevation: 0,
                                onTap: () async {
                                  await showInDialog(
                                    context,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) {
                                      return BookingSummaryDialog(
                                        bookingDataList: widget.bookingData,
                                        bookingId: widget.bookingData.id,
                                      );
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: radius()),
                                    contentPadding: EdgeInsets.zero,
                                  );
                                },
                              ).expand(),
                              16.width,
                            ],
                          ).expand(),
                        AppButton(
                          child: Text(languages!.decline, style: boldTextStyle()),
                          width: context.width(),
                          elevation: 0,
                          color: appStore.isDarkMode ? context.scaffoldBackgroundColor : white,
                          onTap: () {
                            if (isUserTypeProvider) {
                              confirmationRequestDialog(context, widget.index!, BookingStatusKeys.rejected);
                            } else {
                              confirmationRequestDialog(context, widget.index!, BookingStatusKeys.pending);
                            }
                          },
                        ).expand(),
                      ],
                    ).paddingOnly(bottom: 8, left: 8, right: 8, top: 16),
                  if (isUserTypeProvider && widget.bookingData.handyman!.isEmpty && widget.bookingData.status == BookingStatusKeys.accept)
                    Column(
                      children: [
                        8.height,
                        AppButton(
                          width: context.width(),
                          child: Text(languages!.lblAssign, style: boldTextStyle(color: white)),
                          color: primaryColor,
                          elevation: 0,
                          onTap: () {
                            AssignHandymanScreen(
                              bookingId: widget.bookingData.id,
                              serviceAddressId: widget.bookingData.bookingAddressId,
                              onUpdate: () {
                                setState(() {});
                                LiveStream().emit(LIVESTREAM_UPDATE_BOOKINGS);
                              },
                            ).launch(context);
                          },
                        ),
                      ],
                    ).paddingAll(8),
                ],
              ).paddingAll(8),
            ),
        ],
      ), //booking card change
    ).onTap(
      () async {
        BookingDetailScreen(bookingId: widget.bookingData.id).launch(context);
      },
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }
}
