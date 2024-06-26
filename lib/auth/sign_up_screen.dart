import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sun3ah_provider/auth/sign_in_screen.dart';
import 'package:sun3ah_provider/components/app_widgets.dart';
import 'package:sun3ah_provider/components/selected_item_widget.dart';
import 'package:sun3ah_provider/main.dart';
import 'package:sun3ah_provider/models/user_type_response.dart';
import 'package:sun3ah_provider/networks/rest_apis.dart';
import 'package:sun3ah_provider/utils/common.dart';
import 'package:sun3ah_provider/utils/configs.dart';
import 'package:sun3ah_provider/utils/constant.dart';
import 'package:sun3ah_provider/utils/extensions/string_extension.dart';
import 'package:sun3ah_provider/utils/images.dart';
import 'package:sun3ah_provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

bool isNew = false;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController designationCont = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode userTypeFocus = FocusNode();
  FocusNode typeFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode designationFocus = FocusNode();

  String? selectedUserTypeValue;

  List<UserTypeData> userTypeList = [];
  UserTypeData? selectedUserTypeData;

  bool isAcceptedTc = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  //region Widgets

  Widget _buildTopWidget() {
    return Column(
      children: [
        Container(
          width: 85,
          height: 85,
          decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: primaryColor),
          child: Image.asset(profile, height: 45, width: 45, color: white),
        ),
        16.height,
        Text(languages!.lblSignupTitle, style: boldTextStyle(size: 22)),
        16.height,
        Text(
          languages!.lblSignupSubtitle,
          style: secondaryTextStyle(size: 16),
          textAlign: TextAlign.center,
        ).paddingSymmetric(horizontal: 32),
        32.height,
      ],
    );
  }

  Widget _buildFormWidget() {
    return Column(
      children: [
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: fNameCont,
          focus: fNameFocus,
          nextFocus: lNameFocus,
          errorThisFieldRequired: languages!.hintRequired,
          decoration: inputDecoration(context, hint: languages!.hintFirstNameTxt),
          suffix: profile.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: lNameCont,
          focus: lNameFocus,
          nextFocus: userNameFocus,
          errorThisFieldRequired: languages!.hintRequired,
          decoration: inputDecoration(context, hint: languages!.hintLastNameTxt),
          suffix: profile.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.USERNAME,
          controller: userNameCont,
          focus: userNameFocus,
          nextFocus: emailFocus,
          errorThisFieldRequired: languages!.hintRequired,
          decoration: inputDecoration(context, hint: languages!.hintUserNameTxt),
          suffix: profile.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.EMAIL,
          controller: emailCont,
          focus: emailFocus,
          nextFocus: mobileFocus,
          errorThisFieldRequired: languages!.hintRequired,
          decoration: inputDecoration(context, hint: languages!.hintEmailAddressTxt),
          suffix: ic_message.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        AppTextField(
          textFieldType: isAndroid ? TextFieldType.PHONE : TextFieldType.NAME,
          controller: mobileCont,
          focus: mobileFocus,
          buildCounter: (_, {required int currentLength, required bool isFocused, required int? maxLength}) {
            return Offstage();
          },
          nextFocus: designationFocus,
          errorThisFieldRequired: languages!.hintRequired,
          decoration: inputDecoration(context, hint: languages!.hintContactNumberTxt),
          suffix: calling.iconImage(size: 10).paddingAll(14),
          validator: (mobileCont) {
            if (mobileCont!.isEmpty) return languages!.lblPleaseEnterMobileNumber;
            if (isIOS && !RegExp(r"^([0-9]{1,5})-([0-9]{1,10})$").hasMatch(mobileCont)) {
              return languages!.inputMustBeNumberOrDigit;
            }
            if (!mobileCont.trim().contains('-')) return '"-" ${languages!.requiredAfterCountryCode}';
            return null;
          },
        ),
        12.height,
        Align(
          alignment: Alignment.centerRight,
          child: mobileNumberInfoWidget(context),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.USERNAME,
          controller: designationCont,
          isValidationRequired: false,
          focus: designationFocus,
          nextFocus: passwordFocus,
          decoration: inputDecoration(context, hint: languages!.lblDesignation),
          suffix: profile.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        DropdownButtonFormField<String>(
          items: [
            DropdownMenuItem(
              child: Text(languages!.provider, style: primaryTextStyle()),
              value: USER_TYPE_PROVIDER,
            ),
            DropdownMenuItem(
              child: Text(languages!.handyman, style: primaryTextStyle()),
              value: USER_TYPE_HANDYMAN,
            ),
          ],
          focusNode: userTypeFocus,
          dropdownColor: context.cardColor,
          decoration: inputDecoration(context, hint: languages!.lblUserType),
          value: selectedUserTypeValue,
          validator: (value) {
            if (value == null) return errorThisFieldRequired;
            return null;
          },
          onChanged: (c) {
            hideKeyboard(context);
            selectedUserTypeValue = c.validate();

            userTypeList.clear();
            selectedUserTypeData = null;

            getUserType(type: selectedUserTypeValue!).then((value) {
              userTypeList = value.userTypeData.validate();
              setState(() {});
            }).catchError((e) {
              log(e.toString());
            });
          },
        ),
        16.height,
        DropdownButtonFormField<UserTypeData>(
          onChanged: (UserTypeData? val) {
            selectedUserTypeData = val;
            setState(() {});
          },
          validator: selectedUserTypeData == null
              ? (c) {
                  if (c == null) return errorThisFieldRequired;
                  return null;
                }
              : null,
          value: selectedUserTypeData,
          dropdownColor: context.cardColor,
          decoration: inputDecoration(context, hint: languages!.lblSelectUserType),
          items: List.generate(
            userTypeList.length,
            (index) {
              UserTypeData data = userTypeList[index];

              return DropdownMenuItem<UserTypeData>(
                child: Text(data.name.toString(), style: primaryTextStyle()),
                value: data,
              );
            },
          ),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.PASSWORD,
          controller: passwordCont,
          focus: passwordFocus,
          suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
          suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
          errorThisFieldRequired: languages!.hintRequired,
          decoration: inputDecoration(context, hint: languages!.hintPassword),
          onFieldSubmitted: (s) {
            saveUser();
          },
        ),
        20.height,
        _buildTcAcceptWidget(),
        8.height,
        AppButton(
          text: languages!.lblSignup,
          height: 40,
          color: primaryColor,
          textStyle: primaryTextStyle(color: white),
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            saveUser();
          },
        ),
      ],
    );
  }

  Widget _buildFooterWidget() {
    return Column(
      children: [
        16.height,
        RichTextWidget(
          list: [
            TextSpan(text: "${languages!.alreadyHaveAccountTxt}? ", style: secondaryTextStyle()),
            TextSpan(
              text: languages!.signIn,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  finish(context);
                },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTcAcceptWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SelectedItemWidget(isSelected: isAcceptedTc).onTap(() async {
          isAcceptedTc = !isAcceptedTc;
          setState(() {});
        }),
        16.width,
        RichTextWidget(
          list: [
            TextSpan(text: '${languages!.lblIAgree} ', style: secondaryTextStyle()),
            TextSpan(
              text: languages!.lblTermsOfService,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch(TERMS_CONDITION_URL);
                },
            ),
            TextSpan(text: ' & ', style: secondaryTextStyle()),
            TextSpan(
              text: languages!.lblPrivacyPolicy,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch(PRIVACY_POLICY_URL);
                },
            ),
          ],
        ).flexible(flex: 2),
      ],
    ).paddingAll(16);
  }

  //endregion

  //region Methods
  void saveUser() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      hideKeyboard(context);

      if (isAcceptedTc) {
        appStore.setLoading(true);

        var request = {
          UserKeys.firstName: fNameCont.text.trim(),
          UserKeys.lastName: lNameCont.text.trim(),
          UserKeys.userName: userNameCont.text.trim(),
          UserKeys.userType: selectedUserTypeValue,
          UserKeys.contactNumber: mobileCont.text.trim(),
          UserKeys.email: emailCont.text.trim(),
          UserKeys.password: passwordCont.text.trim(),
        };

        if (selectedUserTypeValue == USER_TYPE_PROVIDER) {
          request.putIfAbsent(UserKeys.providerTypeId, () => selectedUserTypeData!.id.toString());
        } else {
          request.putIfAbsent(UserKeys.handymanTypeId, () => selectedUserTypeData!.id.toString());
        }

        log(request);

        await registerUser(request).then((userRegisterData) async {
          userRegisterData.data!.password = passwordCont.text.trim();
          userRegisterData.data!.userType = selectedUserTypeValue;

          await authService.signUpWithEmailPassword(userData: userRegisterData.data!).then((value) {
            if (value) {
              if (userRegisterData.data!.status.validate() == 0) {
                appStore.setLoading(false);
                toast(languages!.pleaseContactAdmin, print: true);

                push(SignInScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
              }
            }
          }).catchError((e) {
            toast(languages!.lblLoginAgain);
            SignInScreen().launch(context, isNewTask: true);
          });
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString(), print: true);
        });
      } else {
        appStore.setLoading(false);
        toast(languages!.lblTermCondition);
      }
    }
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "",
        elevation: 0,
        color: context.scaffoldBackgroundColor,
        systemUiOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: getStatusBrightness(val: appStore.isDarkMode), statusBarColor: context.scaffoldBackgroundColor),
      ),
      body: SizedBox(
        width: context.width(),
        child: Stack(
          children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTopWidget(),
                    _buildFormWidget(),
                    _buildFooterWidget(),
                  ],
                ),
              ),
            ),
            Observer(builder: (context) => LoaderWidget().center().visible(appStore.isLoading))
          ],
        ),
      ),
    );
  }
}
