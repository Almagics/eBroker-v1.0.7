import 'dart:developer';

import 'package:ebroker/data/model/ReportProperty/reason_model.dart';
import 'package:ebroker/data/model/data_output.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Repositories/report_property_repository.dart';

abstract class FetchPropertyReportReasonsListState {}

class FetchPropertyReportReasonsInitial
    extends FetchPropertyReportReasonsListState {}

class FetchPropertyReportReasonsInProgress
    extends FetchPropertyReportReasonsListState {}

class FetchPropertyReportReasonsSuccess
    extends FetchPropertyReportReasonsListState {
  final int total;
  final List<ReportReason> reasons;

  FetchPropertyReportReasonsSuccess(
      {required this.total, required this.reasons});
}

class FetchPropertyReportReasonsFailure
    extends FetchPropertyReportReasonsListState {
  final dynamic error;

  FetchPropertyReportReasonsFailure(this.error);
}

class FetchPropertyReportReasonsListCubit
    extends Cubit<FetchPropertyReportReasonsListState> {
  FetchPropertyReportReasonsListCubit()
      : super(FetchPropertyReportReasonsInitial());
  ReportPropertyRepository _repository = ReportPropertyRepository();
  void fetch() async {
    try {
      emit(FetchPropertyReportReasonsInProgress());
      DataOutput<ReportReason> result =
          await _repository.fetchReportReasonsList();
      print("result");
      print(result);

      result.modelList.add(ReportReason(id: -10, reason: "Other"));

      emit(FetchPropertyReportReasonsSuccess(
        reasons: result.modelList,
        total: result.total,
      ));
    } catch (e) {
      log("PROPERTY REPORT REASON $e");
      emit(FetchPropertyReportReasonsFailure(e));
    }
  }

  List<ReportReason>? getList() {
    if (state is FetchPropertyReportReasonsSuccess) {
      return (state as FetchPropertyReportReasonsSuccess).reasons;
    }
  }
}
