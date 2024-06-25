import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_wisata_renald/data/datasources/category_remote_datasource.dart';
import 'package:flutter_wisata_renald/data/models/response/category_response_model.dart';

part 'category_bloc.freezed.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRemoteDatasource categoryRemoteDatasource;
  CategoryBloc(
    this.categoryRemoteDatasource,
  ) : super(_Initial()) {
    on<_Fetch>((event, emit) async {
      emit(_Loading());
      final response = await categoryRemoteDatasource.getCategories();
      response.fold(
        (error) => emit(_Error(error)),
        (data) => emit(_Success(data.data ?? [])),
      );
    });
  }
}
