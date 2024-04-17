import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../image_model.dart';

part 'main_screen_event.dart';

part 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc() : super(const MainScreenState()) {
    on<MainScreenEvent>(_mapEventToState);
  }

  _mapEventToState(MainScreenEvent event, Emitter<MainScreenState> emit) {
    if (event is GetImagesEvent) {
      return _mapGetImagesEventToState(event, emit);
    }
  }

  void _mapGetImagesEventToState(
      GetImagesEvent event, Emitter<MainScreenState> emit) async {
    http.Response response = await http.get(Uri.parse(
        'https://pixabay.com/api/?key=27162510-5b09007af571a2749f6b55489&q=yellow+flowers&image_type=photo&pretty=true'));
    if (response.statusCode == 200) {
      print("got response.body::${response.body}");
      ImageModel imageModel = ImageModel.fromJson(jsonDecode(response.body));
      emit(state.copyWith(imageList: imageModel.hits));
      print("got dfata here ::::${response.body}");
    }
  }
}
