import 'package:ebroker/data/Repositories/personalized_feed_repository.dart';
import 'package:ebroker/data/model/property_model.dart';

import '../../../Ui/screens/proprties/viewAll.dart';
import '../../../exports/main_export.dart';
import '../../model/data_output.dart';

abstract class FetchPersonalizedPropertyListState {}

class FetchPersonalizedPropertyInitial
    extends FetchPersonalizedPropertyListState {}

class FetchPersonalizedPropertyInProgress
    extends FetchPersonalizedPropertyListState {}

class FetchPersonalizedPropertySuccess
    extends FetchPersonalizedPropertyListState
    implements PropertySuccessStateWireframe {
  @override
  final bool isLoadingMore;
  final bool loadingMoreError;
  @override
  final List<PropertyModel> properties;
  final int offset;
  final int total;
  FetchPersonalizedPropertySuccess(
      {required this.isLoadingMore,
      required this.loadingMoreError,
      required this.properties,
      required this.offset,
      required this.total});

  @override
  set isLoadingMore(bool _isLoadingMore) {
    // TODO: implement isLoadingMore
  }

  @override
  set properties(List<PropertyModel> _properties) {
    // TODO: implement properties
  }

  FetchPersonalizedPropertySuccess copyWith(
      {bool? isLoadingMore,
      bool? loadingMoreError,
      List<PropertyModel>? properties,
      int? offset,
      int? total,
      String? cityName}) {
    return FetchPersonalizedPropertySuccess(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadingMoreError: loadingMoreError ?? this.loadingMoreError,
      properties: properties ?? this.properties,
      offset: offset ?? this.offset,
      total: total ?? this.total,
    );
  }
}

class FetchPersonalizedPropertyFail extends FetchPersonalizedPropertyListState
    implements PropertyErrorStateWireframe {
  final dynamic error;
  FetchPersonalizedPropertyFail(this.error);

  @override
  set error(_error) {
    // TODO: implement error
  }
}

class FetchPersonalizedPropertyList
    extends Cubit<FetchPersonalizedPropertyListState>
    implements PropertyCubitWireframe {
  FetchPersonalizedPropertyList() : super(FetchPersonalizedPropertyInitial());
  final PersonalizedFeedRepository _personalizedFeedRepository =
      PersonalizedFeedRepository();

  @override
  void fetch({bool? forceRefresh}) async {
    if (forceRefresh != true) {
      if (state is FetchPersonalizedPropertySuccess) {
        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await Future.delayed(const Duration(seconds: 5));
        // });
      } else {
        emit(FetchPersonalizedPropertyInProgress());
      }
    } else {
      emit(FetchPersonalizedPropertyInProgress());
    }
    try {
      DataOutput<PropertyModel> result = await _personalizedFeedRepository
          .getPersonalizedProeprties(offset: 0);
      emit(FetchPersonalizedPropertySuccess(
          isLoadingMore: false,
          loadingMoreError: false,
          properties: result.modelList,
          offset: 0,
          total: result.total));
    } catch (e) {
      emit(FetchPersonalizedPropertyFail(e as dynamic));
    }
  }

  @override
  void fetchMore() async {
    try {
      if (state is FetchPersonalizedPropertySuccess) {
        if ((state as FetchPersonalizedPropertySuccess).isLoadingMore) {
          return;
        }
        emit((state as FetchPersonalizedPropertySuccess)
            .copyWith(isLoadingMore: true));
        DataOutput<PropertyModel> result =
            await _personalizedFeedRepository.getPersonalizedProeprties(
          offset: (state as FetchPersonalizedPropertySuccess).properties.length,
        );

        FetchPersonalizedPropertySuccess propertiesState =
            (state as FetchPersonalizedPropertySuccess);
        propertiesState.properties.addAll(result.modelList);
        emit(FetchPersonalizedPropertySuccess(
            isLoadingMore: false,
            loadingMoreError: false,
            properties: propertiesState.properties,
            offset:
                (state as FetchPersonalizedPropertySuccess).properties.length,
            total: result.total));
      }
    } catch (e) {
      emit((state as FetchPersonalizedPropertySuccess)
          .copyWith(isLoadingMore: false, loadingMoreError: true));
    }
  }

  @override
  bool hasMoreData() {
    if (state is FetchPersonalizedPropertySuccess) {
      return (state as FetchPersonalizedPropertySuccess).properties.length <
          (state as FetchPersonalizedPropertySuccess).total;
    }
    return false;
  }
}
