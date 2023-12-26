// ignore_for_file: file_names
import 'package:ebroker/data/model/system_settings_model.dart';
import 'package:flutter/material.dart';

import '../data/model/propery_filter_model.dart';
import '../settings.dart';

const String svgPath = 'assets/svg/';

class Constant {
  static const String appName = AppSettings.applicationName;
  static const String andoidPackageName = AppSettings.andoidPackageName;
  static const String iOSAppId = AppSettings.iOSAppId;
  static const String playstoreURLAndroid = AppSettings.playstoreURLAndroid;
  static const String appstoreURLios = AppSettings.appstoreURLios;
  static const String shareappText = AppSettings.shareAppText;

  //backend url
  static String baseUrl = AppSettings.baseUrl;

  //Add your Own API key here
  static String googlePlaceAPIkey = AppSettings.googlePlaceAPIkey;

  ////Payment gatway API keys
  static String razorpayKey = AppSettings.razorpayKey;

  //paystack
  static String paystackKey = AppSettings.paystackKey; // public key
  static String paystackCurrency = AppSettings.paystackCurrency;

  ///Paypal
  static String paypalClientId = AppSettings.paypalClientId;
  static String paypalServerKey = AppSettings.paypalServerKey; //secrate

  static bool isSandBoxMode = AppSettings.isSandBoxMode; //testing mode
  static String paypalCancelURL = AppSettings.paypalCancelURL;
  static String paypalReturnURL = AppSettings.paypalReturnURL;

  /////////////////////////////////

  // static late Session session;
  static String currencySymbol = "\u{20B9}";
  //
  static int otpTimeOutSecond = AppSettings.otpTimeOutSecond; //otp time out
  static int otpResendSecond = AppSettings.otpResendSecond; // resend otp timer
  //

  static String logintypeMobile = "1"; //always 1
  //
  static String maintenanceMode = "0"; //OFF
  static bool isUserDeactivated = false;
  //
  static String valSellBuy = "0";
  static String valRent = "1";
  //
  static int loadLimit = AppSettings.apiDataLoadLimit;

  static const String defaultCountryCode = AppSettings.defaultCountryCode;

  ///This maxCategoryLength is for show limited number of categories and show "More" button,
  ///You have to set less than [loadLimit] constant

  static const int maxCategoryLength =
      AppSettings.maxCategoryShowLengthInHomeScreen;

  //

  ///Lottie animation
  static const String progressLottieFile = AppSettings.progressLottieFile;
  static const String progressLottieFileWhite = AppSettings
      .progressLottieFileWhite; //When there is dark background and you want to show progress so it will be used

  static const String maintenanceModeLottieFile =
      AppSettings.maintenanceModeLottieFile;

  ///

  ///Put your loading json file in assets/lottie/ folder
  static const bool useLottieProgress = AppSettings
      .useLottieProgress; //if you don't want to use lottie progress then set it to false'

  static const String notificationChannel = AppSettings.notificationChannel;
  static int uploadImageQuality = AppSettings.uploadImageQuality; //0 to 100

  static String? subscriptionPackageId;
  static PropertyFilterModel? propertyFilter;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static String typeRent = "rent";
  static String generalNotification = "0";
  static String enquiryNotification = "1";
  static String notificationPropertyEnquiry = "property_inquiry";
  static String notificationDefault = "default";
  //0: last_week   1: yesterday
  static String filterLastWeek = "0";
  static String filterYesterday = "1";
  static String filterAll = "";
//

  //

  static List<int> interestedPropertyIds = [];
  static List<int> favoritePropertyList = [];

  static Map<dynamic, dynamic> addProperty = {};

  static Map<SystemSetting, String> systemSettingKey = {
    SystemSetting.currencySymball: "currency_symbol",
    SystemSetting.privacyPolicy: "privacy_policy",
    SystemSetting.contactUs: "",
    SystemSetting.maintenanceMode: "maintenance_mode",
    SystemSetting.termsConditions: "terms_conditions",
    SystemSetting.subscription: "subscription",
    SystemSetting.language: "languages",
    SystemSetting.defaultLanguage: "default_language",
    SystemSetting.forceUpdate: "force_update",
    SystemSetting.androidVersion: "android_version",
    SystemSetting.numberWithSuffix: "number_with_suffix",
    SystemSetting.iosVersion: "ios_version"
  };

  ///This is limit of minimum chat messages load count , make sure you set it grater than 25;
  static int minChatMessages = 35;

  static List promotedProeprtiesIds = [];
  //assets/riveAnimations
  static const riveAnimation = "rive_animation.riv";

  ///There are only few RTL languages so we have added it staticly and if you find another one you can add it in list from [settings.dart] file
  static Set totalRtlLanguages = {
    "ar", //Arabic -
    "he", //Hebrew
    "fa", //Persian (Farsi) -
    "ur", //Urdu
    "ps", //Pashto
    "sd", //Sindhi
    "ku", //Kurdish
    "prs", //Dari
    "bal", //Balochi
    "arc", //Aramaic
  }..addAll(
      AppSettings.additionalRTLlanguages,
    );

  static bool showExperimentals = true;

//Don't touch this settings
  static bool isUpdateAvailable = false;
  static String newVersionNumber = "";
  static bool isNumberWithSuffix = false;

  ///

  //demo mode settings
  static bool isDemoModeOn = false;
  static String demoCountryCode = "91";
  static String demoMobileNumber = "1234567890";
  static String demoModeOTP = "123456";
}
