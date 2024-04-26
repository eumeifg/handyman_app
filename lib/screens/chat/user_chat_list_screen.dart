import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:sun3ah_provider/components/app_widgets.dart';
import 'package:sun3ah_provider/components/back_widget.dart';
import 'package:sun3ah_provider/components/background_component.dart';
import 'package:sun3ah_provider/main.dart';
import 'package:sun3ah_provider/models/user_data.dart';
import 'package:sun3ah_provider/screens/chat/components/user_item_widget.dart';
import 'package:sun3ah_provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
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
    return Scaffold(
      appBar: appBarWidget(
        languages!.lblChat,
        textColor: white,
        showBack: Navigator.canPop(context),
        elevation: 3.0,
        backWidget: BackWidget(),
        color: context.primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return await 2.seconds.delay;
        },
        child: FirestorePagination(
          itemBuilder: (context, snap, index) {
            UserData contact = UserData.fromJson(snap.data() as Map<String, dynamic>);

            return UserItemWidget(userUid: contact.uid.validate());
          },
          physics: AlwaysScrollableScrollPhysics(),
          query: chatServices.fetchChatListQuery(userId: appStore.uId.validate()),
          onEmpty: BackgroundComponent(text: languages!.noConversation),
          initialLoader: LoaderWidget(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 10),
          isLive: true,
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 0),
          limit: PER_PAGE_CHAT_LIST_COUNT,
          separatorBuilder: (_, i) => Divider(height: 0, indent: 82),
          viewType: ViewType.list,
        ),
      ),
    );
  }
}
