import 'package:flutter/material.dart';
import 'package:sun3ah_provider/components/app_widgets.dart';
import 'package:sun3ah_provider/components/back_widget.dart';
import 'package:sun3ah_provider/components/background_component.dart';
import 'package:sun3ah_provider/main.dart';
import 'package:sun3ah_provider/models/tax_list_response.dart';
import 'package:sun3ah_provider/networks/rest_apis.dart';
import 'package:sun3ah_provider/utils/colors.dart';
import 'package:sun3ah_provider/utils/common.dart';
import 'package:sun3ah_provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class TaxesScreen extends StatefulWidget {
  @override
  _TaxesScreenState createState() => _TaxesScreenState();
}

class _TaxesScreenState extends State<TaxesScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await 2.seconds.delay;
        setState(() {});
      },
      child: Scaffold(
        key: UniqueKey(),
        appBar: appBarWidget(
          languages!.lblTaxes,
          showBack: true,
          backWidget: BackWidget(),
          textColor: Colors.white,
          color: context.primaryColor,
        ),
        body: FutureBuilder<TaxListResponse>(
          future: getTaxList(),
          builder: (context, snap) {
            if (snap.hasData) {
              return snap.data!.taxData.validate().isNotEmpty
                  ? AnimatedListView(
                      itemCount: snap.data!.taxData!.length,
                      slideConfiguration: SlideConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
                      padding: EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        TaxData data = snap.data!.taxData![index];
                        return Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.all(8),
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radius(),
                            backgroundColor: appStore.isDarkMode ? scaffoldDarkColor : cardColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${languages!.lblTaxName}', style: boldTextStyle(size: 14)),
                                  Text('${data.title.validate()}', style: secondaryTextStyle()),
                                ],
                              ),
                              8.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${languages!.lblMyTax}', style: boldTextStyle(size: 14)),
                                  Row(
                                    children: [
                                      Text(
                                        isCommissionTypePercent(data.type) ? ' ${data.value.validate()} %' : ' ${getStringAsync(CURRENCY_COUNTRY_SYMBOL)}${data.value.validate()}',
                                        style: secondaryTextStyle(),
                                      ),
                                      Text(' (${data.type.capitalizeFirstLetter()})', style: secondaryTextStyle(size: 14)),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : BackgroundComponent(text: languages!.lblNoTaxesFound);
            }
            return snapWidgetHelper(snap, loadingWidget: LoaderWidget());
          },
        ),
      ),
    );
  }
}
