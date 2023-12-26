// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ebroker/data/Repositories/cities_repository.dart';
import 'package:ebroker/data/model/city_model.dart';
import 'package:ebroker/data/model/data_output.dart';
import 'package:ebroker/utils/Extensions/lib/list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FetchCityCategoryState {}

class FetchCityCategoryInitial extends FetchCityCategoryState {}

class FetchCityCategoryInProgress extends FetchCityCategoryState {}

class FetchCityCategorySuccess extends FetchCityCategoryState {
  final List<City> cities;
  final int total;
  FetchCityCategorySuccess({
    required this.cities,
    required this.total,
  });
}

class FetchCityCategoryFail extends FetchCityCategoryState {
  final dynamic error;

  FetchCityCategoryFail(this.error);
}

class FetchCityCategoryCubit extends Cubit<FetchCityCategoryState> {
  FetchCityCategoryCubit() : super(FetchCityCategoryInitial());
  final CitiesRepository _citiesRepository = CitiesRepository();
  void fetchCityCategory() async {
    try {
      emit(FetchCityCategoryInProgress());
      DataOutput<City> result = await _citiesRepository.fetchCitiesData();
      emit(FetchCityCategorySuccess(
          cities: result.modelList, total: result.total));
    } catch (error) {
      emit(FetchCityCategoryFail(error));
    }
  }

  dynamic getCount() {
    if (state is FetchCityCategorySuccess) {
      return (state as FetchCityCategorySuccess).cities.sum((e) => e.count);
    } else {
      return "--";
    }
  }
}
