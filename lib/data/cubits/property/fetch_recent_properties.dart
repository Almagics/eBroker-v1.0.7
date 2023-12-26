import 'dart:developer';

import 'package:ebroker/Ui/screens/proprties/viewAll.dart';
import 'package:ebroker/data/Repositories/property_repository.dart';
import 'package:ebroker/data/model/data_output.dart';
import 'package:ebroker/data/model/property_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FetchRecentPropertiesState {}

class FetchRecentProepertiesInitial extends FetchRecentPropertiesState {}

class FetchRecentPropertiesInProgress extends FetchRecentPropertiesState {}

class FetchRecentPropertiesSuccess extends FetchRecentPropertiesState
    implements PropertySuccessStateWireframe {
  final int total;
  final int offset;
  @override
  final bool isLoadingMore;
  final bool hasError;
  @override
  final List<PropertyModel> properties;

  FetchRecentPropertiesSuccess({
    required this.total,
    required this.offset,
    required this.isLoadingMore,
    required this.hasError,
    required this.properties,
  });

  FetchRecentPropertiesSuccess copyWith({
    int? total,
    int? offset,
    bool? isLoadingMore,
    bool? hasError,
    List<PropertyModel>? properties,
  }) {
    return FetchRecentPropertiesSuccess(
      total: total ?? this.total,
      offset: offset ?? this.offset,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      properties: properties ?? this.properties,
    );
  }

  @override
  set properties(List<PropertyModel> _properties) {
    // TODO: implement properties
  }

  @override
  set isLoadingMore(bool _isLoadingMore) {
    // TODO: implement isLoadingMore
  }
}

class FetchRecentPropertiesFailur extends FetchRecentPropertiesState
    implements PropertyErrorStateWireframe {
  final dynamic error;

  FetchRecentPropertiesFailur(this.error);

  @override
  set error(_error) {}
}

class FetchRecentPropertiesCubit extends Cubit<FetchRecentPropertiesState>
    with PropertyCubitWireframe {
  FetchRecentPropertiesCubit() : super(FetchRecentProepertiesInitial());

  final PropertyRepository _propertyRepository = PropertyRepository();
  @override
  void fetch({bool? forceRefresh}) async {
    try {
      if (forceRefresh != true) {
        if (state is FetchRecentPropertiesSuccess) {
          // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          await Future.delayed(const Duration(seconds: 5));
          // });
        } else {
          emit(FetchRecentPropertiesInProgress());
        }
      } else {
        emit(FetchRecentPropertiesInProgress());
      }

      DataOutput<PropertyModel> result =
          await _propertyRepository.fetchRecentProperties(offset: 0);

      emit(FetchRecentPropertiesSuccess(
          total: result.total,
          offset: 0,
          isLoadingMore: false,
          hasError: false,
          properties: result.modelList));
    } catch (e) {
      emit(FetchRecentPropertiesFailur(e.toString()));
    }
  }

  @override
  void fetchMore() async {
    if (state is FetchRecentPropertiesSuccess) {
      FetchRecentPropertiesSuccess mystate =
          (state as FetchRecentPropertiesSuccess);
      if (mystate.isLoadingMore) {
        return;
      }
      emit((state as FetchRecentPropertiesSuccess)
          .copyWith(isLoadingMore: true));
      DataOutput<PropertyModel> result =
          await _propertyRepository.fetchRecentProperties(
        offset: (state as FetchRecentPropertiesSuccess).properties.length,
      );
      FetchRecentPropertiesSuccess propertymodelState =
          (state as FetchRecentPropertiesSuccess);
      propertymodelState.properties.addAll(result.modelList);
      emit(FetchRecentPropertiesSuccess(
          isLoadingMore: false,
          hasError: false,
          properties: propertymodelState.properties,
          offset: (state as FetchRecentPropertiesSuccess).properties.length,
          total: result.total));
    }
  }

  @override
  bool hasMoreData() {
    if (state is FetchRecentPropertiesSuccess) {
      log("HAS MORE DATA CALLED ${(state as FetchRecentPropertiesSuccess).properties.length} & ${(state as FetchRecentPropertiesSuccess).total}");

      return (state as FetchRecentPropertiesSuccess).properties.length <
          (state as FetchRecentPropertiesSuccess).total;
    }
    return false;
  }
}
