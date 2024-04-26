import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sun3ah_provider/locale/applocalizations.dart';
import 'package:sun3ah_provider/locale/base_language.dart';
import 'package:sun3ah_provider/models/add_extra_charges_model.dart';
import 'package:sun3ah_provider/models/file_model.dart';
import 'package:sun3ah_provider/models/remote_config_data_model.dart';
import 'package:sun3ah_provider/models/revenue_chart_data.dart';
import 'package:sun3ah_provider/networks/firebase_services/auth_services.dart';
import 'package:sun3ah_provider/networks/firebase_services/chat_messages_service.dart';
import 'package:sun3ah_provider/networks/firebase_services/notification_service.dart';
import 'package:sun3ah_provider/networks/firebase_services/user_services.dart';
import 'package:sun3ah_provider/screens/booking_detail_screen.dart';
import 'package:sun3ah_provider/screens/splash_screen.dart';
import 'package:sun3ah_provider/store/AppStore.dart';
import 'package:sun3ah_provider/utils/common.dart';
import 'package:sun3ah_provider/utils/configs.dart';
import 'package:sun3ah_provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'app_theme.dart';
import 'provider/timeSlots/timeSlotStore/time_slot_store.dart';

//region Mobx Stores
AppStore appStore = AppStore();
TimeSlotStore timeSlotStore = TimeSlotStore();
//endregion

//region App languages
Languages? languages;
//endregion

//region Firebase Services
UserService userService = UserService();
AuthService authService = AuthService();

ChatServices chatServices = ChatServices();
NotificationService notificationService = NotificationService();
//endregion

//region Chart Model
late List<FileModel> fileList = [];
List<RevenueChartData> chartData = [];
//endregion

//region Chat Variable
bool mIsEnterKey = false;
String currentPackageName = '';
//endregion

RemoteConfigDataModel remoteConfigDataModel = RemoteConfigDataModel();

//region Chat Variable
List<AddExtraChargesModel> chargesList = [];
//endregion

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!isDesktop) {
    Firebase.initializeApp().then((value) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

      setupFirebaseRemoteConfig();
    }).catchError((e) {
      log(e.toString());
    });
  }

  defaultSettings();

  await initialize();

  localeLanguageList = languageList();

  appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE));

  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));

  await setLoginValues();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult notification) {
      try {
        var notId = notification.notification.additionalData!.containsKey('id') ? notification.notification.additionalData!['id'] : 0;
        push(BookingDetailScreen(bookingId: notId.toString().toInt()));
      } catch (e) {
        throw errorSomethingWentWrong;
      }
    });
    afterBuildCreated(() {
      int val = getIntAsync(THEME_MODE_INDEX);

      if (val == THEME_MODE_LIGHT) {
        appStore.setDarkMode(false);
      } else if (val == THEME_MODE_DARK) {
        appStore.setDarkMode(true);
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RestartAppWidget(
      child: Observer(
        builder: (_) => MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          home: SplashScreen(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          supportedLocales: LanguageDataModel.languageLocales(),
          localizationsDelegates: [
            AppLocalizations(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) => locale,
          locale: Locale(appStore.selectedLanguageCode),
        ),
      ),
    );
  }
}
