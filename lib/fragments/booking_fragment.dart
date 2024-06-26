import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sun3ah_provider/components/app_widgets.dart';
import 'package:sun3ah_provider/components/background_component.dart';
import 'package:sun3ah_provider/components/booking_item_component.dart';
import 'package:sun3ah_provider/components/booking_status_dropdown.dart';
import 'package:sun3ah_provider/main.dart';
import 'package:sun3ah_provider/models/booking_list_response.dart';
import 'package:sun3ah_provider/models/booking_status_response.dart';
import 'package:sun3ah_provider/networks/rest_apis.dart';
import 'package:sun3ah_provider/utils/constant.dart';
import 'package:sun3ah_provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class BookingFragment extends StatefulWidget {
  String? statusType;

  BookingFragment({this.statusType});

  @override
  BookingFragmentState createState() => BookingFragmentState();
}

class BookingFragmentState extends State<BookingFragment> with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  int page = 1;
  List<BookingData> bookings = [];

  String selectedValue = BOOKING_TYPE_ALL;
  bool isLastPage = false;
  bool hasError = false;
  bool isApiCalled = false;

  Future<List<BookingData>>? future;
  UniqueKey keyForStatus = UniqueKey();
  bool isBookingTypeChanged = false;

  @override
  void initState() {
    super.initState();
    LiveStream().on(LIVESTREAM_HANDY_BOARD, (index) {
      if (index is Map && index["index"] == 1) {
        selectedValue = BookingStatusKeys.accept;
        fetchAllBookingList();
        setState(() {});
      }
    });

    LiveStream().on(LIVESTREAM_HANDYMAN_ALL_BOOKING, (index) {
      if (index == 1) {
        selectedValue = '';
        fetchAllBookingList();
      }
    });

    LiveStream().on(LIVESTREAM_UPDATE_BOOKINGS, (p0) {
      page = 1;
      fetchAllBookingList();
    });

    init();
  }

  void init() async {
    if (widget.statusType.validate().isNotEmpty) {
      selectedValue = widget.statusType.validate();
    }

    fetchAllBookingList(loading: true);
  }

  Future<void> fetchAllBookingList({bool loading = true}) async {
    future = getBookingList(page, status: selectedValue, bookings: bookings, lastPageCallback: (b) {
      isLastPage = b;
    });
    isBookingTypeChanged = false;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(LIVESTREAM_UPDATE_BOOKINGS);
    LiveStream().dispose(LIVESTREAM_HANDY_BOARD);
    // LiveStream().dispose(LIVESTREAM_HANDYMAN_ALL_BOOKING);
    // LiveStream().dispose(LIVESTREAM_HANDY_BOARD);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          page = 1;
          fetchAllBookingList();

          setState(() {});
          return await 2.seconds.delay;
        },
        child: SizedBox(
          width: context.width(),
          height: context.height(),
          child: Stack(
            children: [
              SnapHelperWidget<List<BookingData>>(
                future: future,
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    onRetry: () {
                      keyForStatus = UniqueKey();
                      page = 1;
                      fetchAllBookingList();
                      setState(() {});
                    },
                  );
                },
                loadingWidget: LoaderWidget(),
                onSuccess: (list) {
                  if (list.isEmpty) {
                    return BackgroundComponent(
                      text: languages!.noBookingTitle,
                      subTitle: languages!.noBookingSubTitle,
                    );
                  }

                  return AnimatedListView(
                    controller: scrollController,
                    onSwipeRefresh: () async {
                      page = 1;
                      return await fetchAllBookingList(loading: false);
                    },
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: bookings.length,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    slideConfiguration: SlideConfiguration(verticalOffset: 400, delay: 50.milliseconds),
                    itemBuilder: (_, index) => BookingItemComponent(bookingData: bookings[index], index: index),
                    //disposeScrollController: false,
                    onNextPage: () {
                      if (!isLastPage) {
                        page++;
                        fetchAllBookingList();
                      }
                    },
                  ).paddingOnly(left: 0, right: 0, bottom: 0, top: 76);
                },
              ),
              Positioned(
                left: 16,
                right: 16,
                top: 16,
                child: BookingStatusDropdown(
                  isValidate: false,
                  statusType: selectedValue,
                  key: keyForStatus,
                  onValueChanged: (BookingStatusResponse value) {
                    page = 1;

                    if (bookings.isNotEmpty) {
                      scrollController.animateTo(0, duration: 1.seconds, curve: Curves.easeOutQuart);
                    } else {
                      scrollController = ScrollController();
                    }
                    selectedValue = value.value.validate(value: BOOKING_TYPE_ALL);
                    fetchAllBookingList(loading: true);
                    setState(() { });
                  },
                ),
              ),
              Positioned(
                bottom: isBookingTypeChanged ? 100 : 8,
                left: 0,
                right: 0,
                child: Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading && (page != 1 || isBookingTypeChanged)).center()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
