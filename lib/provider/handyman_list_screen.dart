import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sun3ah_provider/components/app_widgets.dart';
import 'package:sun3ah_provider/components/background_component.dart';
import 'package:sun3ah_provider/components/handyman_add_update_screen.dart';
import 'package:sun3ah_provider/main.dart';
import 'package:sun3ah_provider/models/user_data.dart';
import 'package:sun3ah_provider/networks/rest_apis.dart';
import 'package:sun3ah_provider/provider/components/handyman_widget.dart';
import 'package:sun3ah_provider/utils/colors.dart';
import 'package:sun3ah_provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class HandymanListScreen extends StatefulWidget {
  @override
  HandymanListScreenState createState() => HandymanListScreenState();
}

class HandymanListScreenState extends State<HandymanListScreen> {
  ScrollController scrollController = ScrollController();
  List<UserData> userData = [];
  bool afterInit = false;

  int totalPage = 0;
  int currentPage = 1;
  int totalItems = 0;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();

    afterBuildCreated(() {
      setStatusBarColor(context.primaryColor);
      appStore.setLoading(true);
      init();
    });
  }

  Future<void> init() async {
    scrollController.addListener(() {
      if (currentPage <= totalPage) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
          currentPage++;
          appStore.setLoading(true);
          getHandymanList();
        }
      }
    });
    getHandymanList();
  }

  Future<void> getHandymanList() async {
    appStore.setLoading(true);
    await getHandyman(page: currentPage, isPagination: true, providerId: appStore.userId).then((value) {
      totalItems = value.pagination!.totalItems;

      if (currentPage == 1) {
        userData.clear();
      }

      if (totalItems != 0) {
        userData.addAll(value.data!);
        print(value);
        totalPage = value.pagination!.totalPages!;
        currentPage = value.pagination!.currentPage!;
      }

      afterInit = true;
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      toast(e.toString(), print: true);
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        currentPage = 1;
        return await getHandymanList();
      },
      child: Scaffold(
        backgroundColor: appStore.isDarkMode ? blackColor : cardColor,
        appBar: appBarWidget(
          languages!.lblAllHandyman,
          textColor: white,
          color: context.primaryColor,
          actions: [
            IconButton(
              onPressed: () {
                HandymanAddUpdateScreen(
                  userType: USER_TYPE_HANDYMAN,
                  onUpdate: () {
                    appStore.setLoading(true);
                    getHandymanList();
                  },
                ).launch(context);
              },
              icon: Icon(Icons.add, size: 28, color: white),
              tooltip: languages!.lblAddHandyman,
            ),
          ],
        ),
        body: Observer(
          builder: (_) => Stack(
            children: [
              if (userData.isNotEmpty)
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  controller: scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: AnimatedWrap(
                    spacing: 16,
                    runSpacing: 16,
                    itemCount: userData.length,
                    scaleConfiguration: ScaleConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
                    listAnimationType: ListAnimationType.Scale,
                    itemBuilder: (context, index) {
                      return HandymanWidget(
                        data: userData[index],
                        width: context.width() * 0.5 - 26,
                        onUpdate: () async {
                          currentPage = 1;

                          appStore.setLoading(true);
                          getHandymanList();
                        },
                      );
                    },
                  ),
                ),
              BackgroundComponent(text: languages!.noHandymanYet).visible(userData.isEmpty && afterInit),
              LoaderWidget().center().visible(appStore.isLoading && !afterInit),
            ],
          ),
        ),
      ),
    );
  }
}
