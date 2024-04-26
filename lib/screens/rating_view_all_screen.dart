import 'package:flutter/material.dart';
import 'package:sun3ah_provider/components/app_widgets.dart';
import 'package:sun3ah_provider/components/back_widget.dart';
import 'package:sun3ah_provider/components/background_component.dart';
import 'package:sun3ah_provider/components/review_list_view_component.dart';
import 'package:sun3ah_provider/main.dart';
import 'package:sun3ah_provider/models/booking_detail_response.dart';
import 'package:sun3ah_provider/networks/rest_apis.dart';
import 'package:sun3ah_provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

/// Pass serviceId if you want to get service reviews
/// Pass handymanId if you want to get handyman reviews
/// Pass any one at a time
class RatingViewAllScreen extends StatelessWidget {
  final int? serviceId;
  final int? handymanId;
  final String? title;
  final bool showServiceName;

  RatingViewAllScreen({this.serviceId, this.handymanId, this.title, this.showServiceName = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title ?? languages!.lblServiceRatings, color: context.primaryColor, textColor: Colors.white, backWidget: BackWidget()),
      body: SnapHelperWidget<List<RatingData>>(
        future: serviceId != null ? serviceReviews({CommonKeys.serviceId: serviceId}) : handymanReviews({CommonKeys.handymanId: handymanId}),
        loadingWidget: LoaderWidget(),
        onSuccess: (data) {
          if (data.isNotEmpty) {
            return ReviewListViewComponent(ratings: data, isCustomer: true, showServiceName: showServiceName);
          } else {
            return BackgroundComponent(
              text: languages!.getYourFirstReview,
              subTitle: languages!.ratingViewAllSubtitle,
            );
          }
        },
      ),
    );
  }
}
