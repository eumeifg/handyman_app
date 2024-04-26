import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sun3ah_provider/components/app_widgets.dart';
import 'package:sun3ah_provider/main.dart';
import 'package:sun3ah_provider/models/dashboard_response.dart';
import 'package:sun3ah_provider/networks/rest_apis.dart';
import 'package:sun3ah_provider/provider/components/chart_component.dart';
import 'package:sun3ah_provider/provider/components/commission_component.dart';
import 'package:sun3ah_provider/provider/components/handyman_list_component.dart';
import 'package:sun3ah_provider/provider/components/handyman_recently_online_component.dart';
import 'package:sun3ah_provider/provider/components/job_list_component.dart';
import 'package:sun3ah_provider/provider/components/services_list_component.dart';
import 'package:sun3ah_provider/provider/components/total_component.dart';
import 'package:sun3ah_provider/provider/subscription/pricing_plan_screen.dart';
import 'package:sun3ah_provider/utils/common.dart';
import 'package:sun3ah_provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/upcoming_booking_component.dart';

class ProviderHomeFragment extends StatefulWidget {
  @override
  _ProviderHomeFragmentState createState() => _ProviderHomeFragmentState();
}

class _ProviderHomeFragmentState extends State<ProviderHomeFragment> {
  int currentIndex = 0;

 late Future<DashboardResponse> future;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = providerDashboard();
  }

  Widget _buildHeaderWidget(DashboardResponse data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Text("${languages!.lblHello}, ${appStore.userFullName}", style: boldTextStyle(size: 20)).paddingLeft(16),
        8.height,
        Text(languages!.lblWelcomeBack, style: secondaryTextStyle(size: 16)).paddingLeft(16),
      ],
    );
  }

  Widget planBanner(DashboardResponse data) {
    if (data.isPlanExpired!) {
      return subSubscriptionPlanWidget(
        planBgColor: appStore.isDarkMode ? context.cardColor : Colors.red.shade50,
        planTitle: languages!.lblPlanExpired,
        planSubtitle: languages!.lblPlanSubTitle,
        planButtonTxt: languages!.btnTxtBuyNow,
        btnColor: Colors.red,
        onTap: () {
          PricingPlanScreen().launch(context);
        },
      );
    } else if (data.userNeverPurchasedPlan!) {
      return subSubscriptionPlanWidget(
        planBgColor: appStore.isDarkMode ? context.cardColor : Colors.red.shade50,
        planTitle: languages!.lblChooseYourPlan,
        planSubtitle: languages!.lblRenewSubTitle,
        planButtonTxt: languages!.btnTxtBuyNow,
        btnColor: Colors.red,
        onTap: () {
          PricingPlanScreen().launch(context);
        },
      );
    } else if (data.isPlanAboutToExpire!) {
      int days = getRemainingPlanDays();

      if (days != 0 && days <= PLAN_REMAINING_DAYS) {
        return subSubscriptionPlanWidget(
          planBgColor: appStore.isDarkMode ? context.cardColor : Colors.orange.shade50,
          planTitle: languages!.lblReminder,
          planSubtitle: languages!.planAboutToExpire(days),
          planButtonTxt: languages!.lblRenew,
          btnColor: Colors.orange,
          onTap: () {
            PricingPlanScreen().launch(context);
          },
        );
      } else {
        return SizedBox();
      }
    } else {
      return SizedBox();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        init();
        setState(() {});
        return await 2.seconds.delay;
      },
      child: Scaffold(
        body: Stack(
          children: [
            FutureBuilder<DashboardResponse>(
              future: future,
              builder: (context, snap) {
                if (snap.hasError) {
                  return NoDataWidget(
                    title: snap.error.toString(),
                    onRetry: () {
                      init();
                      setState(() {});
                    },
                  );
                } else if (snap.hasData) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 16),
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((snap.data!.earningType == EARNING_TYPE_SUBSCRIPTION)) planBanner(snap.data!),
                        _buildHeaderWidget(snap.data!),
                        if (snap.data!.earningType == EARNING_TYPE_COMMISSION) CommissionComponent(commission: snap.data!.commission!),
                        TotalComponent(snap: snap.data!),
                        ChartComponent(),
                        HandymanRecentlyOnlineComponent(images: snap.data!.onlineHandyman.validate()),
                        HandymanListComponent(list: snap.data!.handyman.validate()),
                        UpcomingBookingComponent(bookingData: snap.data!.upcomingBookings.validate()),
                        JobListComponent(list: snap.data!.myPostJobData.validate()).paddingOnly(left: 16, right: 16, top: 8),
                        ServiceListComponent(list: snap.data!.service.validate()),
                      ],
                    ),
                  );
                }

                return snapWidgetHelper(snap, loadingWidget: LoaderWidget(), errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    onRetry: () {
                      init();
                      setState(() {});
                    },
                  );
                });
              },
            ),
            Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
          ],
        ),
      ),
    );
  }
}
