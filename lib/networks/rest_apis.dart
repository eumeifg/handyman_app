import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sun3ah_provider/auth/sign_in_screen.dart';
import 'package:sun3ah_provider/components/app_widgets.dart';
import 'package:sun3ah_provider/main.dart';
import 'package:sun3ah_provider/models/Package_response.dart';
import 'package:sun3ah_provider/models/base_response.dart';
import 'package:sun3ah_provider/models/booking_detail_response.dart';
import 'package:sun3ah_provider/models/booking_list_response.dart';
import 'package:sun3ah_provider/models/booking_status_response.dart';
import 'package:sun3ah_provider/models/caregory_response.dart';
import 'package:sun3ah_provider/models/city_list_response.dart';
import 'package:sun3ah_provider/models/country_list_response.dart';
import 'package:sun3ah_provider/models/dashboard_response.dart';
import 'package:sun3ah_provider/models/document_list_response.dart';
import 'package:sun3ah_provider/models/handyman_dashboard_response.dart';
import 'package:sun3ah_provider/models/login_response.dart';
import 'package:sun3ah_provider/models/notification_list_response.dart';
import 'package:sun3ah_provider/models/payment_list_reasponse.dart';
import 'package:sun3ah_provider/models/plan_list_response.dart';
import 'package:sun3ah_provider/models/plan_request_model.dart';
import 'package:sun3ah_provider/models/profile_update_response.dart';
import 'package:sun3ah_provider/models/provider_document_list_response.dart';
import 'package:sun3ah_provider/models/provider_info_model.dart';
import 'package:sun3ah_provider/models/provider_subscription_model.dart';
import 'package:sun3ah_provider/models/register_response.dart';
import 'package:sun3ah_provider/models/search_list_response.dart';
import 'package:sun3ah_provider/models/service_address_response.dart';
import 'package:sun3ah_provider/models/service_detail_response.dart';
import 'package:sun3ah_provider/models/service_model.dart';
import 'package:sun3ah_provider/models/service_response.dart';
import 'package:sun3ah_provider/models/service_review_response.dart';
import 'package:sun3ah_provider/models/state_list_response.dart';
import 'package:sun3ah_provider/models/subscription_history_model.dart';
import 'package:sun3ah_provider/models/tax_list_response.dart';
import 'package:sun3ah_provider/models/total_earning_response.dart';
import 'package:sun3ah_provider/models/user_data.dart';
import 'package:sun3ah_provider/models/user_info_response.dart';
import 'package:sun3ah_provider/models/user_list_response.dart';
import 'package:sun3ah_provider/models/user_type_response.dart';
import 'package:sun3ah_provider/models/verify_transaction_response.dart';
import 'package:sun3ah_provider/networks/network_utils.dart';
import 'package:sun3ah_provider/provider/jobRequest/models/post_job_detail_response.dart';
import 'package:sun3ah_provider/provider/jobRequest/models/post_job_response.dart';
import 'package:sun3ah_provider/provider/provider_dashboard_screen.dart';
import 'package:sun3ah_provider/provider/timeSlots/models/slot_data.dart';
import 'package:sun3ah_provider/utils/common.dart';
import 'package:sun3ah_provider/utils/configs.dart';
import 'package:sun3ah_provider/utils/constant.dart';
import 'package:sun3ah_provider/utils/images.dart';
import 'package:sun3ah_provider/utils/model_keys.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/my_bid_response.dart';
import '../models/notification_response.dart';
import '../models/wallet_history_list_response.dart';
import '../provider/jobRequest/models/bidder_data.dart';
import '../provider/jobRequest/models/post_job_data.dart';

//region Auth API
Future<void> logout(BuildContext context) async {
  showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    builder: (_) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(logout_logo, width: context.width(), fit: BoxFit.cover),
              32.height,
              Text(languages!.lblDeleteTitle, style: boldTextStyle(size: 20)),
              16.height,
              Text(languages!.lblDeleteSubTitle, style: secondaryTextStyle()),
              28.height,
              Row(
                children: [
                  AppButton(
                    child: Text(languages!.lblNo, style: boldTextStyle()),
                    color: context.cardColor,
                    elevation: 0,
                    onTap: () {
                      finish(context);
                    },
                  ).expand(),
                  16.width,
                  AppButton(
                    child: Text(languages!.lblYes, style: boldTextStyle(color: white)),
                    color: primaryColor,
                    elevation: 0,
                    onTap: () async {
                      if (await isNetworkAvailable()) {
                        appStore.setLoading(true);
                        await logoutApi().then((value) async {}).catchError((e) {
                          appStore.setLoading(false);
                          toast(e.toString());
                        });

                        appStore.setLoading(false);

                        await appStore.setFirstName('');
                        await appStore.setLastName('');
                        if (!getBoolAsync(IS_REMEMBERED)) await appStore.setUserEmail('');
                        await appStore.setUserName('');
                        await appStore.setContactNumber('');
                        await appStore.setCountryId(0);
                        await appStore.setStateId(0);
                        await appStore.setCityId(0);
                        await appStore.setUId('');
                        await appStore.setToken('');
                        await appStore.setCurrencySymbol('');
                        await appStore.setLoggedIn(false);
                        await appStore.setPlanSubscribeStatus(false);
                        await appStore.setPlanTitle('');
                        await appStore.setIdentifier('');
                        await appStore.setPlanEndDate('');
                        await appStore.setTester(false);
                        await appStore.setPrivacyPolicy('');
                        await appStore.setTermConditions('');
                        await appStore.setInquiryEmail('');
                        await appStore.setHelplineNumber('');

                        SignInScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                      } else {
                        toast(errorInternetNotAvailable);
                      }
                    },
                  ).expand(),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 24),
          Observer(builder: (_) => LoaderWidget().withSize(width: 60, height: 60).visible(appStore.isLoading)),
        ],
      );
    },
  );
}

Future<void> clearPreferences() async {
  await appStore.setFirstName('');
  await appStore.setLastName('');
  if (!getBoolAsync(IS_REMEMBERED)) await appStore.setUserEmail('');
  await appStore.setUserName('');
  await appStore.setContactNumber('');
  await appStore.setCountryId(0);
  await appStore.setStateId(0);
  await appStore.setCityId(0);
  await appStore.setUId('');
  await appStore.setToken('');
  await appStore.setCurrencySymbol('');
  await appStore.setLoggedIn(false);
  await appStore.setPlanSubscribeStatus(false);
  await appStore.setPlanTitle('');
  await appStore.setIdentifier('');
  await appStore.setPlanEndDate('');
  await appStore.setTester(false);
  await appStore.setPrivacyPolicy('');
  await appStore.setTermConditions('');
  await appStore.setInquiryEmail('');
  await appStore.setHelplineNumber('');
}

Future<void> logoutApi() async {
  return await handleResponse(await buildHttpResponse('logout', method: HttpMethod.GET));
}

Future<RegisterResponse> registerUser(Map request) async {
  return RegisterResponse.fromJson(await (handleResponse(await buildHttpResponse('register', request: request, method: HttpMethod.POST))));
}

Future<LoginResponse> loginUser(Map request) async {
  LoginResponse res = LoginResponse.fromJson(await (handleResponse(await buildHttpResponse('login', request: request, method: HttpMethod.POST))));

  return res;
}

Future<void> saveUserData(UserData data) async {
  if (data.status == 1) {
    if (data.apiToken != null) await appStore.setToken(data.apiToken.validate());
    await appStore.setUserId(data.id.validate());
    await appStore.setFirstName(data.firstName.validate());
    await appStore.setUserType(data.userType.validate());
    await appStore.setLastName(data.lastName.validate());
    await appStore.setUserEmail(data.email.validate());
    await appStore.setUserName(data.username.validate());
    await appStore.setContactNumber('${data.contactNumber.validate()}');
    await appStore.setUserProfile(data.profileImage.validate());
    await appStore.setCountryId(data.countryId.validate());
    await appStore.setStateId(data.stateId.validate());
    await appStore.setDesignation(data.designation.validate());
    log('${data.email.validate()}');
    await userService.getUser(email: data.email.validate().toLowerCase()).then((value) async {
      await appStore.setUId(value.uid.validate());
    }).catchError((e) {
      log(e.toString());
    });
    await appStore.setCityId(data.cityId.validate());
    await appStore.setProviderId(data.providerId.validate());
    if (data.serviceAddressId != null) await appStore.setServiceAddressId(data.serviceAddressId!);
    await appStore.setCreatedAt(data.createdAt.validate());
    if (data.subscription != null) {
      await setSaveSubscription(
        isSubscribe: data.isSubscribe,
        title: data.subscription!.title.validate(),
        identifier: data.subscription!.identifier.validate(),
        endAt: data.subscription!.endAt.validate(),
      );
    }

    /* if (data.userType.validate() == USER_TYPE_PROVIDER) {
      timeSlotStore.setForAllServices(value: data.isSlotsForAllServices, isInitializing: true);
    }
*/
    await appStore.setAddress(data.address.validate().isNotEmpty ? data.address.validate() : '');

    await appStore.setLoggedIn(true);
  }
}

Future<BaseResponseModel> changeUserPassword(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('change-password', request: request, method: HttpMethod.POST)));
}

Future<UserInfoResponse> getUserDetail(int id) async {
  return UserInfoResponse.fromJson(await handleResponse(await buildHttpResponse('user-detail?id=$id', method: HttpMethod.GET)));
}

Future<HandymanInfoResponse> getProviderDetail(int id) async {
  return HandymanInfoResponse.fromJson(await handleResponse(await buildHttpResponse('user-detail?id=$id', method: HttpMethod.GET)));
}

Future<BaseResponseModel> forgotPassword(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('forgot-password', request: request, method: HttpMethod.POST)));
}

Future<CommonResponseModel> updateProfile(Map request) async {
  return CommonResponseModel.fromJson(await handleResponse(await buildHttpResponse('update-profile', request: request, method: HttpMethod.POST)));
}
//endregion

//region Country API
Future<List<CountryListResponse>> getCountryList() async {
  Iterable res = await (handleResponse(await buildHttpResponse('country-list', method: HttpMethod.POST)));
  return res.map((e) => CountryListResponse.fromJson(e)).toList();
}

Future<List<StateListResponse>> getStateList(Map request) async {
  Iterable res = await (handleResponse(await buildHttpResponse('state-list', request: request, method: HttpMethod.POST)));
  return res.map((e) => StateListResponse.fromJson(e)).toList();
}

Future<List<CityListResponse>> getCityList(Map request) async {
  Iterable res = await (handleResponse(await buildHttpResponse('city-list', request: request, method: HttpMethod.POST)));
  return res.map((e) => CityListResponse.fromJson(e)).toList();
}
//endregion

//region Category API
Future<CategoryResponse> getCategoryList({String perPage = ''}) async {
  return CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('category-list?per_page=$perPage', method: HttpMethod.GET)));
}
//endregion

//region SubCategory Api
Future<CategoryResponse> getSubCategoryList({required int catId}) async {
  String categoryId = catId != -1 ? "category_id=$catId" : "";
  String perPage = catId != -1 ? '&per_page=all' : '?per_page=all';
  return CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('subcategory-list?$categoryId$perPage', method: HttpMethod.GET)));
}
//endregion

//region Provider API
Future<DashboardResponse> providerDashboard() async {
  DashboardResponse data = DashboardResponse.fromJson(await handleResponse(await buildHttpResponse('provider-dashboard', method: HttpMethod.GET)));

  if (data.appDownload != null) {
    setValue(PROVIDER_PLAY_STORE_URL, data.appDownload!.provider_playstore_url.validate());
    setValue(PROVIDER_APPSTORE_URL, data.appDownload!.provider_appstore_url.validate());
  }

  setCurrencies(value: data.configurations, paymentSetting: data.paymentSettings);

  data.configurations.validate().forEach((data) {
    if (data.key == ONESIGNAL_APP_ID_PROVIDER) {
      if (data.value.validate().isNotEmpty) {
        setValue(ONESIGNAL_APP_ID_PROVIDER, data.value);
      }
    } else if (data.key == ONESIGNAL_REST_API_KEY_PROVIDER) {
      if (data.value.validate().isNotEmpty) {
        setValue(ONESIGNAL_REST_API_KEY_PROVIDER, data.value);
      }
    } else if (data.key == ONESIGNAL_CHANNEL_KEY_PROVIDER) {
      if (data.value.validate().isNotEmpty) {
        setValue(ONESIGNAL_CHANNEL_KEY_PROVIDER, data.value);
      }
    }
  });
  1.seconds.delay.then((value) {
    setOneSignal();
  });

  if (data.subscription != null) {
    await setSaveSubscription(
      isSubscribe: data.isSubscribed,
      title: data.subscription!.title.validate(),
      identifier: data.subscription!.identifier.validate(),
      endAt: data.subscription!.endAt.validate(),
    );
  }

  appStore.setNotificationCount(data.notification_unread_count.validate());

  if (data.earningType == EARNING_TYPE_SUBSCRIPTION) {
    await setValue(IS_PLAN_SUBSCRIBE, true);
  } else {
    await setValue(IS_PLAN_SUBSCRIBE, false);
  }
  appStore.setEarningType(data.earningType.validate());

  if (data.privacyPolicy != null) {
    if (data.privacyPolicy!.value.validate().isNotEmpty) {
      appStore.setPrivacyPolicy(data.privacyPolicy!.value.validate());
    } else {
      appStore.setPrivacyPolicy(PRIVACY_POLICY_URL);
    }
  } else {
    appStore.setPrivacyPolicy(PRIVACY_POLICY_URL);
  }
  if (data.termConditions != null) {
    if (data.termConditions!.value.validate().isNotEmpty) {
      appStore.setTermConditions(data.termConditions!.value.validate());
    } else {
      appStore.setTermConditions(TERMS_CONDITION_URL);
    }
  } else {
    appStore.setTermConditions(TERMS_CONDITION_URL);
  }

  if (data.inquriyEmail.validate().isNotEmpty) {
    appStore.setInquiryEmail(data.inquriyEmail.validate());
  } else {
    appStore.setInquiryEmail(HELP_SUPPORT_URL);
  }

  if (data.helplineNumber.validate().isNotEmpty) {
    appStore.setHelplineNumber(data.helplineNumber.validate());
  }

  if (data.languageOption != null) {
    setValue(SERVER_LANGUAGES, jsonEncode(data.languageOption!.toList()));
  }

  return data;
}

Future<ProviderDocumentListResponse> getProviderDoc() async {
  return ProviderDocumentListResponse.fromJson(await handleResponse(await buildHttpResponse('provider-document-list', method: HttpMethod.GET)));
}

Future<CommonResponseModel> deleteProviderDoc(int? id) async {
  return CommonResponseModel.fromJson(await handleResponse(await buildHttpResponse('provider-document-delete/$id', method: HttpMethod.POST)));
}
//endregion

//region Handyman API
Future<HandymanDashBoardResponse> handymanDashboard() async {
  HandymanDashBoardResponse data = HandymanDashBoardResponse.fromJson(await handleResponse(await buildHttpResponse('handyman-dashboard', method: HttpMethod.GET)));

  setCurrencies(value: data.configurations);
  appStore.setCompletedBooking(data.completedBooking.validate().toInt());
  appStore.setNotificationCount(data.notification_unread_count.validate());

  if (data.privacyPolicy != null) {
    if (data.privacyPolicy!.value.validate().isNotEmpty) {
      appStore.setPrivacyPolicy(data.privacyPolicy!.value.validate());
    } else {
      appStore.setPrivacyPolicy(PRIVACY_POLICY_URL);
    }
  } else {
    appStore.setPrivacyPolicy(PRIVACY_POLICY_URL);
  }

  data.configurations.validate().forEach((data) {
    if (data.key == ONESIGNAL_APP_ID_PROVIDER) {
      if (data.value.validate().isNotEmpty) {
        setValue(ONESIGNAL_APP_ID_PROVIDER, data.value);
      }
    } else if (data.key == ONESIGNAL_REST_API_KEY_PROVIDER) {
      if (data.value.validate().isNotEmpty) {
        setValue(ONESIGNAL_REST_API_KEY_PROVIDER, data.value);
      }
    } else if (data.key == ONESIGNAL_CHANNEL_KEY_PROVIDER) {
      if (data.value.validate().isNotEmpty) {
        setValue(ONESIGNAL_CHANNEL_KEY_PROVIDER, data.value);
      }
    }
  });
  1.seconds.delay.then((value) {
    setOneSignal();
  });

  if (data.termConditions != null) {
    if (data.termConditions!.value.validate().isNotEmpty) {
      appStore.setTermConditions(data.termConditions!.value.validate());
    } else {
      appStore.setTermConditions(TERMS_CONDITION_URL);
    }
  } else {
    appStore.setTermConditions(TERMS_CONDITION_URL);
  }

  if (data.inquriyEmail.validate().isNotEmpty) {
    appStore.setInquiryEmail(data.inquriyEmail.validate());
  } else {
    appStore.setInquiryEmail(HELP_SUPPORT_URL);
  }

  if (data.helplineNumber.validate().isNotEmpty) {
    appStore.setHelplineNumber(data.helplineNumber.validate());
  }

  if (data.languageOption != null) {
    setValue(SERVER_LANGUAGES, jsonEncode(data.languageOption!.toList()));
  }

  appStore.setHandymanAvailability(data.isHandymanAvailable.validate());

  return data;
}

Future<BaseResponseModel> updateHandymanStatus(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('user-update-status', request: request, method: HttpMethod.POST)));
}

Future<UserListResponse> getHandyman({bool isPagination = false, int? page, int? providerId, String? userTypeHandyman = "handyman"}) async {
  if (isPagination) {
    return UserListResponse.fromJson(
        await handleResponse(await buildHttpResponse('user-list?user_type=$userTypeHandyman&provider_id=$providerId&per_page=$PER_PAGE_ITEM&page=$page', method: HttpMethod.GET)));
  } else {
    return UserListResponse.fromJson(await handleResponse(await buildHttpResponse('user-list?user_type=$userTypeHandyman&provider_id=$providerId', method: HttpMethod.GET)));
  }
}

Future<List<UserData>> getAllHandyman({int? page, int? serviceAddressId, required List<UserData> userData, Function(bool)? lastPageCallback}) async {
  appStore.setLoading(true);

  UserListResponse res = UserListResponse.fromJson(
    await handleResponse(await buildHttpResponse('user-list?user_type=handyman&provider_id=${appStore.userId}&per_page=$PER_PAGE_ITEM&page=$page', method: HttpMethod.GET)),
  );

  if (page == 1) userData.clear();

  userData.addAll(res.data.validate());

  lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);
  appStore.setLoading(false);

  return userData;
}

Future<UserData> deleteHandyman(int id) async {
  return UserData.fromJson(await handleResponse(await buildHttpResponse('handyman-delete/$id', method: HttpMethod.POST)));
}

Future<BaseResponseModel> restoreHandyman(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('handyman-action', request: request, method: HttpMethod.POST)));
}

//endregion

//region Service API
Future<ServiceResponse> getServiceList(int page, int providerId, {String? searchTxt, bool isSearch = false, int? categoryId, bool isCategoryWise = false}) async {
  if (isCategoryWise) {
    return ServiceResponse.fromJson(
        await handleResponse(await buildHttpResponse('service-list?per_page=$PER_PAGE_ITEM&category_id=$categoryId&page=$page&provider_id=$providerId', method: HttpMethod.GET)));
  } else if (isSearch) {
    return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse('service-list?per_page=$PER_PAGE_ITEM&page=$page&search=$searchTxt&provider_id=$providerId', method: HttpMethod.GET)));
  } else {
    return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse('service-list?per_page=$PER_PAGE_ITEM&page=$page&provider_id=$providerId', method: HttpMethod.GET)));
  }
}

Future<ServiceDetailResponse> getServiceDetail(Map request) async {
  return ServiceDetailResponse.fromJson(await handleResponse(await buildHttpResponse('service-detail', request: request, method: HttpMethod.POST)));
}

Future<CommonResponseModel> deleteService(int id) async {
  return CommonResponseModel.fromJson(await handleResponse(await buildHttpResponse('service-delete/$id', method: HttpMethod.POST)));
}

Future<BaseResponseModel> deleteImage(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('remove-file', request: request, method: HttpMethod.POST)));
}

Future<void> addServiceMultiPart({required Map<String, dynamic> value, List<int>? serviceAddressList, List<File>? imageFile}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('service-save');

  multiPartRequest.fields.addAll(await getMultipartFields(val: value));

  if (serviceAddressList.validate().isNotEmpty) {
    for (int i = 0; i < serviceAddressList!.length; i++) {
      multiPartRequest.fields[AddServiceKey.providerAddressId + '[$i]'] = serviceAddressList[i].toString().validate();
    }
  }

  if (imageFile.validate().isNotEmpty) {
    multiPartRequest.files.addAll(await getMultipartImages(files: imageFile.validate(), name: AddServiceKey.serviceAttachment));
    multiPartRequest.fields[AddServiceKey.attachmentCount] = imageFile.validate().length.toString();
  }

  log("${multiPartRequest.fields}");

  multiPartRequest.headers.addAll(buildHeaderTokens());

  log("Multi Part Request : ${jsonEncode(multiPartRequest.fields)} ${multiPartRequest.files.map((e) => e.field + ": " + e.filename.validate())}");

  appStore.setLoading(true);

  await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
    appStore.setLoading(false);

    log("Response: ${jsonDecode(temp)}");

    toast(jsonDecode(temp)['message'], print: true);
    finish(getContext, true);
  }, onError: (error) {
    toast(error.toString(), print: true);
    appStore.setLoading(false);
  }).catchError((e) {
    appStore.setLoading(false);
    toast(e.toString());
  });
}
//endregion

//region Booking API
Future<List<BookingStatusResponse>> bookingStatus() async {
  Iterable res = await (handleResponse(await buildHttpResponse('booking-status', method: HttpMethod.GET)));
  return res.map((e) => BookingStatusResponse.fromJson(e)).toList();
}

Future<List<BookingData>> getBookingList(int page, {var perPage = PER_PAGE_ITEM, String status = '', required List<BookingData> bookings, Function(bool)? lastPageCallback}) async {
  appStore.setLoading(true);
  BookingListResponse res;

  if (status == BOOKING_TYPE_ALL) {
    res = BookingListResponse.fromJson(await handleResponse(await buildHttpResponse('booking-list?per_page=$perPage&page=$page', method: HttpMethod.GET)));
  } else {
    res = BookingListResponse.fromJson(await handleResponse(await buildHttpResponse('booking-list?status=$status&per_page=$perPage&page=$page', method: HttpMethod.GET)));
  }

  if (page == 1) bookings.clear();
  bookings.addAll(res.data.validate());
  lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

  appStore.setLoading(false);

  return bookings;
}

Future<SearchListResponse> getServicesList(int page, {var perPage = PER_PAGE_ITEM, int? categoryId = -1, int? subCategoryId = -1, int? providerId, String? search, String? type}) async {
  String? req;
  String categoryIds = categoryId != -1 ? 'category_id=$categoryId&' : '';
  String searchPara = search.validate().isNotEmpty ? 'search=$search&' : '';
  String subCategorys = subCategoryId != -1 ? 'subcategory_id=$subCategoryId&' : '';
  String pages = 'page=$page&';
  String perPages = 'per_page=$PER_PAGE_ITEM';
  String providerIds = appStore.isLoggedIn ? 'provider_id=${appStore.userId}&' : '';
  String serviceType = type.validate().isNotEmpty ? 'type=$type&' : "";

  req = '?$categoryIds$providerIds$subCategorys$serviceType$searchPara$pages$perPages';
  return SearchListResponse.fromJson(await handleResponse(await buildHttpResponse('search-list$req', method: HttpMethod.GET)));
}

Future<List<ServiceData>> getSearchList(
  int page, {
  var perPage = PER_PAGE_ITEM,
  int? categoryId = -1,
  int? subCategoryId = -1,
  int? providerId,
  String? search,
  String? type,
  required List<ServiceData> services,
  Function(bool)? lastPageCallback,
}) async {
  appStore.setLoading(true);
  SearchListResponse res;

  String? req;
  String categoryIds = categoryId != -1 ? 'category_id=$categoryId&' : '';
  String searchPara = search.validate().isNotEmpty ? 'search=$search&' : '';
  String subCategorys = subCategoryId != -1 ? 'subcategory_id=$subCategoryId&' : '';
  String pages = 'page=$page&';
  String perPages = 'per_page=$PER_PAGE_ITEM';
  String providerIds = appStore.isLoggedIn ? 'provider_id=${appStore.userId}&' : '';
  String serviceType = type.validate().isNotEmpty ? 'type=$type&' : "";

  req = '?$categoryIds$providerIds$subCategorys$serviceType$searchPara$pages$perPages';
  res = SearchListResponse.fromJson(await handleResponse(await buildHttpResponse('search-list$req', method: HttpMethod.GET)));

  if (page == 1) services.clear();
  services.addAll(res.data.validate());
  lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

  appStore.setLoading(false);

  return services;
}

Future<BookingDetailResponse> bookingDetail(Map request) async {
  BookingDetailResponse bookingDetailResponse = BookingDetailResponse.fromJson(
    await handleResponse(await buildHttpResponse('booking-detail', request: request, method: HttpMethod.POST)),
  );

  calculateTotalAmount(
    serviceDiscountPercent: bookingDetailResponse.service!.discount.validate(),
    qty: bookingDetailResponse.bookingDetail!.quantity.validate().toInt(),
    detail: bookingDetailResponse.service,
    servicePrice: bookingDetailResponse.service!.price.validate(),
    taxes: bookingDetailResponse.bookingDetail!.taxes.validate(),
    couponData: bookingDetailResponse.couponData,
    extraCharges: bookingDetailResponse.bookingDetail!.extraCharges,
  );

  return bookingDetailResponse;
}

Future<BaseResponseModel> bookingUpdate(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('booking-update', request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> assignBooking(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('booking-assigned', request: request, method: HttpMethod.POST)));
}
//endregion

//region Address API
Future<ServiceAddressesResponse> getAddresses({int? providerId}) async {
  return ServiceAddressesResponse.fromJson(await handleResponse(await buildHttpResponse('provideraddress-list?provider_id=$providerId', method: HttpMethod.GET)));
}

Future<BaseResponseModel> addAddresses(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-provideraddress', request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> removeAddress(int? id) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('provideraddress-delete/$id', method: HttpMethod.POST)));
}
//endregion

//region Reviews API
Future<List<RatingData>> serviceReviews(Map request) async {
  ServiceReviewResponse res = ServiceReviewResponse.fromJson(await handleResponse(await buildHttpResponse('service-reviews?per_page=all', request: request, method: HttpMethod.POST)));

  return res.data.validate();
}

Future<List<RatingData>> handymanReviews(Map request) async {
  ServiceReviewResponse res = ServiceReviewResponse.fromJson(await handleResponse(await buildHttpResponse('handyman-reviews?per_page=all', request: request, method: HttpMethod.POST)));
  return res.data.validate();
}
//endregion

//region Subscription API
Future<PlanListResponse> getPricingPlanList() async {
  return PlanListResponse.fromJson(await handleResponse(await buildHttpResponse('plan-list', method: HttpMethod.GET)));
}

Future<ProviderSubscriptionModel> saveSubscription(Map request) async {
  return ProviderSubscriptionModel.fromJson(await handleResponse(await buildHttpResponse('save-subscription', request: request, method: HttpMethod.POST)));
}

Future<List<ProviderSubscriptionModel>> getSubscriptionHistory(
    {int? page, int? perPage = PER_PAGE_ITEM, required List<ProviderSubscriptionModel> providerSubscriptionList, Function(bool)? lastPageCallback}) async {
  SubscriptionHistoryResponse res =
      SubscriptionHistoryResponse.fromJson(await handleResponse(await buildHttpResponse('subscription-history?per_page=$perPage&page=$page&orderby=desc', method: HttpMethod.GET)));

  appStore.setLoading(true);

  if (page == 1) providerSubscriptionList.clear();

  providerSubscriptionList.addAll(res.data.validate());

  lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

  appStore.setLoading(false);

  return providerSubscriptionList;
}

Future<void> cancelSubscription(Map request) async {
  return await handleResponse(await buildHttpResponse('cancel-subscription', request: request, method: HttpMethod.POST));
}

Future<void> savePayment({
  ProviderSubscriptionModel? data,
  String? paymentStatus = SERVICE_PAYMENT_STATUS_PENDING,
  String? paymentMethod,
  String? txtId,
}) async {
  if (data != null) {
    PlanRequestModel planRequestModel = PlanRequestModel()
      ..amount = data.amount
      ..description = data.description
      ..duration = data.duration
      ..identifier = data.identifier
      ..otherTransactionDetail = ''
      ..paymentStatus = paymentStatus.validate()
      ..paymentType = paymentMethod.validate()
      ..planId = data.id
      ..planLimitation = data.planLimitation
      ..planType = data.planType
      ..title = data.title
      ..txnId = txtId
      ..type = data.type
      ..userId = appStore.userId;

    appStore.setLoading(true);
    log('Request : $planRequestModel');

    await saveSubscription(planRequestModel.toJson()).then((value) {
      toast("${data.title.validate()}  is successFully activated");
      // toast("${data.title.validate()} ${languages!.lblIsSuccessFullyActivated}");
      push(ProviderDashboardScreen(index: 0), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    }).catchError((e) {
      log(e.toString());
    }).whenComplete(() => appStore.setLoading(false));
  }
}

Future<WalletHistoryListResponse> getWalletHistory(int page, {var perPage = PER_PAGE_ITEM}) async {
  return WalletHistoryListResponse.fromJson(await handleResponse(await buildHttpResponse('wallet-history?per_page=$perPage&page=$page&orderby=desc', method: HttpMethod.GET)));
}

Future<BaseResponseModel> updateHandymanAvailabilityApi({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('handyman-update-available-status', request: request, method: HttpMethod.POST)));
}

//endregion

//region Payment API
Future<PaymentListResponse> getPaymentList(int page, {var perPage = PER_PAGE_ITEM}) async {
  return PaymentListResponse.fromJson(await handleResponse(await buildHttpResponse('payment-list?per_page="$perPage"&page=$page', method: HttpMethod.GET)));
}
//endregion

//region Common API
Future<TaxListResponse> getTaxList() async {
  return TaxListResponse.fromJson(await handleResponse(await buildHttpResponse('tax-list', method: HttpMethod.GET)));
}

Future<NotificationResponse> getNotification(Map request, {int? page = 1}) async {
  var res = NotificationListResponse.fromJson(await handleResponse(await buildHttpResponse('notification-list?page=$page', request: request, method: HttpMethod.POST)));

  var notificationResponse = NotificationResponse();

  notificationResponse.unReadNotificationList = [];
  notificationResponse.readNotificationList = [];

  if (notificationResponse.unReadNotificationList!.isNotEmpty) {
    notificationResponse.unReadNotificationList!.clear();
  }
  if (notificationResponse.readNotificationList!.isNotEmpty) {
    notificationResponse.readNotificationList!.clear();
  }
  notificationResponse.unReadNotificationList = res.notificationData!.where((element) => element.readAt == null).toList();
  notificationResponse.readNotificationList = res.notificationData!.where((element) => element.readAt != null).toList();

  return notificationResponse;
}

Future<DocumentListResponse> getDocList() async {
  return DocumentListResponse.fromJson(await handleResponse(await buildHttpResponse('document-list', method: HttpMethod.GET)));
}

Future<TotalEarningResponse> getTotalEarningList(int page, {var perPage = PER_PAGE_ITEM}) async {
  return TotalEarningResponse.fromJson(
      await handleResponse(await buildHttpResponse('${isUserTypeProvider ? 'provider-payout-list' : 'handyman-payout-list'}?per_page="$perPage"&page=$page', method: HttpMethod.GET)));
}

Future<UserTypeResponse> getUserType({String type = USER_TYPE_PROVIDER}) async {
  return UserTypeResponse.fromJson(await handleResponse(await buildHttpResponse('type-list?type=$type')));
}

Future<BaseResponseModel> deleteAccountCompletely() async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-account', request: {}, method: HttpMethod.POST)));
}
//endregion

//region Post Job Request
Future<List<PostJobData>> getPostJobList(int page, {var perPage = PER_PAGE_ITEM, required List<PostJobData> postJobList, Function(bool)? lastPageCallback}) async {
  appStore.setLoading(true);
  try {
    var res = PostJobResponse.fromJson(await handleResponse(await buildHttpResponse('get-post-job?per_page=$perPage&page=$page', method: HttpMethod.GET)));

    if (page == 1) {
      postJobList.clear();
    }

    lastPageCallback?.call(res.postJobData.validate().length != PER_PAGE_ITEM);

    postJobList.addAll(res.postJobData.validate());
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }

  return postJobList;
}

Future<PostJobDetailResponse> getPostJobDetail(Map request) async {
  return PostJobDetailResponse.fromJson(await handleResponse(await buildHttpResponse('get-post-job-detail', request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> saveBid(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-bid', request: request, method: HttpMethod.POST)));
}

Future<List<BidderData>> getBidList({int page = 1, var perPage = PER_PAGE_ITEM, required List<BidderData> bidList, Function(bool)? lastPageCallback}) async {
  appStore.setLoading(true);

  try {
    var res = MyBidResponse.fromJson(await handleResponse(await buildHttpResponse('get-bid-list?orderby=desc', method: HttpMethod.GET)));

    if (page == 1) {
      bidList.clear();
    }

    lastPageCallback?.call(res.bidData.validate().length != PER_PAGE_ITEM);

    bidList.addAll(res.bidData.validate());
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
  return bidList;
}
//endregion

// region Package service API
Future<List<PackageData>> getAllPackageList({int? page, required List<PackageData> packageData, Function(bool)? lastPageCallback}) async {
  appStore.setLoading(true);

  PackageResponse res = PackageResponse.fromJson(
    await handleResponse(await buildHttpResponse('package-list?per_page=$PER_PAGE_ITEM&page=$page', method: HttpMethod.GET)),
  );

  if (page == 1) packageData.clear();

  packageData.addAll(res.packageList.validate());

  lastPageCallback?.call(res.packageList.validate().length != PER_PAGE_ITEM);

  appStore.setLoading(false);

  return packageData;
}

Future<void> addPackageMultiPart({required Map<String, dynamic> value, List<File>? imageFile}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('package-save');

  multiPartRequest.fields.addAll(await getMultipartFields(val: value));

  if (imageFile.validate().isNotEmpty) {
    multiPartRequest.files.addAll(await getMultipartImages(files: imageFile.validate(), name: PackageKey.packageAttachment));
    multiPartRequest.fields[AddServiceKey.attachmentCount] = imageFile.validate().length.toString();
  }

  log("${multiPartRequest.fields}");

  multiPartRequest.headers.addAll(buildHeaderTokens());

  log("MultiPart Request : ${jsonEncode(multiPartRequest.fields)} ${multiPartRequest.files.map((e) => e.field + ": " + e.filename.validate())}");

  appStore.setLoading(true);

  await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
    appStore.setLoading(false);

    appStore.selectedServiceList.clear();
    log("Response: ${jsonDecode(temp)}");

    toast(jsonDecode(temp)['message'], print: true);
    finish(getContext, true);
  }, onError: (error) {
    toast(error.toString(), print: true);
    appStore.setLoading(false);
  }).catchError((e) {
    appStore.setLoading(false);
    toast(e.toString());
  });
}

Future<CommonResponseModel> deletePackage(int id) async {
  return CommonResponseModel.fromJson(await handleResponse(await buildHttpResponse('package-delete/$id', method: HttpMethod.POST)));
}

//region FlutterWave Verify Transaction API
Future<VerifyTransactionResponse> verifyPayment({required String transactionId, required String flutterWaveSecretKey}) async {
  return VerifyTransactionResponse.fromJson(
      await handleResponse(await buildHttpResponse("https://api.flutterwave.com/v3/transactions/$transactionId/verify", isFlutterWave: true, flutterWaveSecretKey: flutterWaveSecretKey)));
}
//endregion

//region TimeSlots
Future<BaseResponseModel> updateAllServicesApi({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('provider-all-services-timeslots', request: request, method: HttpMethod.POST)));
}

Future<List<SlotData>> getProviderSlot({int? val}) async {
  String providerId = val != null ? "?provider_id=$val" : '';
  Iterable res = await handleResponse(await buildHttpResponse('get-provider-slot$providerId', method: HttpMethod.GET));
  return res.map((e) => SlotData.fromJson(e)).toList();
}

Future<List<SlotData>> getProviderServiceSlot({int? providerId, int? serviceId}) async {
  String pId = providerId != null ? "?provider_id=$providerId" : '';
  String sId = serviceId != null ? "&service_id=$serviceId" : '';
  Iterable res = await handleResponse(await buildHttpResponse('get-service-slot$pId$sId', method: HttpMethod.GET));
  return res.map((e) => SlotData.fromJson(e)).toList();
}

Future<BaseResponseModel> saveProviderSlot(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-provider-slot', request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> saveServiceSlot(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-service-slot', request: request, method: HttpMethod.POST)));
}

//endregion

//region CommonFunctions
Future<Map<String, String>> getMultipartFields({required Map<String, dynamic> val}) async {
  Map<String, String> data = {};

  val.forEach((key, value) {
    data[key] = '$value';
  });

  return data;
}

Future<List<MultipartFile>> getMultipartImages({required List<File> files, required String name}) async {
  List<MultipartFile> multiPartRequest = [];

  await Future.forEach<File>(files, (element) async {
    int i = files.indexOf(element);

    multiPartRequest.add(await MultipartFile.fromPath('${'$name' + i.toString()}', element.path));
  });

  return multiPartRequest;
}
//endregion

//region Sadad Payment Api
Future<String> sadadLogin(Map request) async {
  var res = await handleResponse(await buildHttpResponse('$SADAD_API_URL/api/userbusinesses/login', method: HttpMethod.POST, request: request, isSadadPayment: true));
  return res['accessToken'];
}

Future sadadCreateInvoice({required Map<String, dynamic> request, required String sadadToken}) async {
  return handleResponse(
    await buildHttpResponse('$SADAD_API_URL/api/invoices/createInvoice', method: HttpMethod.POST, request: request, isSadadPayment: true, sadadToken: sadadToken),
  );
}
//endregion
