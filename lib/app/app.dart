import 'dart:developer';

import 'package:ebroker/Ui/screens/widgets/Erros/something_went_wrong.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../data/Repositories/system_repository.dart';
import '../data/model/Personalized/personalized_settings.dart';
import '../firebase_options.dart';
import '../main.dart';
import '../utils/Notification/notification_service.dart';
import '../utils/api.dart';
import '../utils/hive_keys.dart';
import '../utils/hive_utils.dart';

PersonalizedInterestSettings personalizedInterestSettings =
    PersonalizedInterestSettings.empty();

void initApp() async {
  ///Note: this file's code is very necessary and sensitive if you change it, this might affect whole app , So change it carefully.
  ///This must be used do not remove this line
  WidgetsFlutterBinding.ensureInitialized();

  ///This is the widget to show uncaught runtime error in this custom widget so that user can know in that screen something is wrong instead of grey screen
  if (kReleaseMode) {
    ErrorWidget.builder =
        (FlutterErrorDetails flutterErrorDetails) => SomethingWentWrong(
              error: flutterErrorDetails,
            );
  }

  if (Firebase.apps.isNotEmpty) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } else {
    await Firebase.initializeApp();
  }

  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  );

  FirebaseMessaging.onBackgroundMessage(
      NotificationService.onBackgroundMessageHandler);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  await Hive.initFlutter();
  await Hive.openBox(HiveKeys.userDetailsBox);
  await Hive.openBox(HiveKeys.authBox);
  await Hive.openBox(HiveKeys.languageBox);
  await Hive.openBox(HiveKeys.themeBox);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    runApp(const EntryPoint());
  });
}

// code: fr, name: French, file_name:
Future getDefaultLanguage(VoidCallback onSuccess) async {
  try {
    if (HiveUtils.getLanguage() == null ||
        HiveUtils.getLanguage()?['data'] == null) {
      Map result =
          await SystemRepository().fetchSystemSettings(isAnonymouse: true);
      var code = (result['data']['default_language']);

      await Api.post(
        url: Api.getLanguagae,
        parameter: {Api.languageCode: code},
        useAuthToken: false,
      ).then((value) {
        HiveUtils.storeLanguage({
          "code": value['data'][0]['code'],
          "data": value['data'][0]['file_name'],
          "name": value['data'][0]['name']
        });
        onSuccess.call();
      });
    } else {
      onSuccess.call();
    }
  } catch (e) {
    log("Error while load default language $e");
  }
}
