import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/api.dart';
import '../../utils/constant.dart';
import '../helper/custom_exception.dart';

abstract class ProfileSettingState {}

//String? profileSettingData = '';

class ProfileSettingInitial extends ProfileSettingState {}

class ProfileSettingFetchProgress extends ProfileSettingState {}

class ProfileSettingFetchSuccess extends ProfileSettingState {
  String data;
  ProfileSettingFetchSuccess(this.data);
}

class ProfileSettingFetchFailure extends ProfileSettingState {
  final String errmsg;
  ProfileSettingFetchFailure(this.errmsg);
}

class ProfileSettingCubit extends Cubit<ProfileSettingState> {
  ProfileSettingCubit() : super(ProfileSettingInitial());

  void fetchProfileSetting(BuildContext context, String title) {
    emit(ProfileSettingFetchProgress());

    fetchProfileSettingFromDb(context, title).then((value) {
      emit(ProfileSettingFetchSuccess(value ?? ""));
    }).catchError((e, st) {
      log(st.toString(), name: "ISSUE IS");
      emit(ProfileSettingFetchFailure(st.toString()));
    });
  }

  Future<String?> fetchProfileSettingFromDb(
      BuildContext context, String title) async {
    try {
      String? profileSettingData;
      Map<String, String> body = {
        Api.type: title,
      };

      var response = await Api.post(
          url: Api.apiGetSystemSettings, parameter: body, useAuthToken: false);

      if (!response[Api.error]) {
        if (title == Api.currencySymbol) {
          // Constant.currencySymbol = getdata['data'].toString();
        } else if (title == Api.maintenanceMode) {
          Constant.maintenanceMode = response['data'].toString();
        } else {
          Map data = (response['data']);

          if (title == Api.termsAndConditions) {
            profileSettingData = data['terms_conditions'];
            // .where((element) => element['type'] == "terms_conditions")
            // .first['data'];
          }

          if (title == Api.privacyPolicy) {
            profileSettingData = data['privacy_policy'];
            // .where((element) => element['type'] == "privacy_policy")
            // .first['data'];
          }

          if (title == Api.aboutApp) {
            profileSettingData = data['about_us'];
            // .where((element) => element['type'] == "about_us")
            // .first['data'];
          }
        }
      } else {
        throw CustomException(response[Api.message]);
      }

      return profileSettingData;
    } catch (e, st) {
      log(st.toString(), name: "FETCNH");
      throw e;
    }
  }
}
