import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sun3ah_provider/components/app_widgets.dart';
import 'package:sun3ah_provider/components/back_widget.dart';
import 'package:sun3ah_provider/components/background_component.dart';
import 'package:sun3ah_provider/main.dart';
import 'package:sun3ah_provider/models/wallet_history_list_response.dart';
import 'package:sun3ah_provider/networks/rest_apis.dart';
import 'package:sun3ah_provider/provider/wallet/components/wallet_widget.dart';
import 'package:sun3ah_provider/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

class WalletHistoryScreen extends StatefulWidget {
  @override
  WalletHistoryScreenState createState() => WalletHistoryScreenState();
}

class WalletHistoryScreenState extends State<WalletHistoryScreen> {
  List<WalletHistory> walletHistoryList = [];

  int totalPage = 0;
  int currentPage = 1;
  int totalItems = 0;

  bool hasError = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  init() async {
    appStore.setLoading(true);
    await getWalletHistory(currentPage).then((value) {
      appStore.setLoading(false);
      hasError = false;
      totalItems = value.pagination!.totalItems!;

      if (currentPage == 1) {
        walletHistoryList.clear();
      }
      if (totalItems >= 1) {
        walletHistoryList.addAll(value.data!);
        totalPage = value.pagination!.totalPages!;
        currentPage = value.pagination!.currentPage!;
      }
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages!.lblWalletHistory, backWidget: BackWidget(), elevation: 0, color: primaryColor, textColor: Colors.white),
      body: Stack(
        children: [
          if (walletHistoryList.isNotEmpty)
            AnimatedListView(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              slideConfiguration: SlideConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
              padding: EdgeInsets.all(8),
              itemCount: walletHistoryList.length,
              itemBuilder: (_, i) => WalletWidget(walletHistoryList[i]),
              onNextPage: () {
                if (currentPage <= totalPage) {
                  currentPage++;
                  init();
                }
              },
            ),
          Observer(
            builder: (_) {
              return BackgroundComponent(
                text: languages!.noWalletHistoryTitle,
                subTitle: languages!.noWalletHistorySubTitle,
              ).visible(!appStore.isLoading && walletHistoryList.isEmpty && !hasError);
            },
          ),
          Text(errorSomethingWentWrong, style: secondaryTextStyle()).center().visible(hasError),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
