import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/constant.dart';
import '../../Repositories/system_repository.dart';
import '../../model/system_settings_model.dart';

abstract class FetchSystemSettingsState {}

class FetchSystemSettingsInitial extends FetchSystemSettingsState {}

class FetchSystemSettingsInProgress extends FetchSystemSettingsState {}

class FetchSystemSettingsSuccess extends FetchSystemSettingsState {
  final Map settings;
  FetchSystemSettingsSuccess({
    required this.settings,
  });
}

class FetchSystemSettingsFailure extends FetchSystemSettingsState {
  final String errorMessage;

  FetchSystemSettingsFailure(this.errorMessage);
}

class FetchSystemSettingsCubit extends Cubit<FetchSystemSettingsState> {
  FetchSystemSettingsCubit() : super(FetchSystemSettingsInitial());
  final SystemRepository _systemRepository = SystemRepository();
  Future<void> fetchSettings({required bool isAnonymouse}) async {
    try {
      emit(FetchSystemSettingsInProgress());

      log("SYSTEM SETTING LOADING");
      Map settings = await _systemRepository.fetchSystemSettings(
          isAnonymouse: isAnonymouse);
      Constant.currencySymbol =
          _getSetting(settings, SystemSetting.currencySymball);
      log("SETTINGS ARE $settings");

      emit(FetchSystemSettingsSuccess(settings: settings));
    } catch (e) {
      log("ERROR $e");
      emit(FetchSystemSettingsFailure(e.toString()));
    }
  }

  dynamic getSetting(SystemSetting selected) {
    if (state is FetchSystemSettingsSuccess) {
      Map settings = (state as FetchSystemSettingsSuccess).settings['data'];
      if (selected == SystemSetting.subscription) {
        //check if we have subscribed to any package if true then return this data otherwise return empty list
        if (settings['subscription'] == true) {
          log("THIS IS SUBSCRIPTION ${settings['package']['user_purchased_package'] as List}");
          return settings['package']['user_purchased_package'] as List;
        } else {
          return [];
        }
      }

      if (selected == SystemSetting.language) {
        return settings['languages'];
      }

      if (selected == SystemSetting.demoMode) {
        if (settings.containsKey("demo_mode")) {
          return settings['demo_mode'];
        } else {
          return false;
        }
      }

      /// where selected is equals to type
      var selectedSettingData = (settings[Constant.systemSettingKey[selected]]);

      //     .where(
      //   (element) {
      //     return element['type'] == Constant.systemSettingKey[selected];
      //   },
      // ).toList()[0]['data'];

      return selectedSettingData;
    }
  }

  dynamic _getSetting(Map settings, SystemSetting selected) {
    var selectedSettingData =
        settings['data'][Constant.systemSettingKey[selected]];
    // var selectedSettingData = (settings['data'] as List)
    //     .where(
    //       (element) => element['type'] == Constant.systemSettingKey[selected],
    //     )
    //     .toList()[0]['data'];
    return selectedSettingData;
  }
}
