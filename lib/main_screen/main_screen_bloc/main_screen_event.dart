part of 'main_screen_bloc.dart';

class MainScreenEvent extends Equatable {
  const MainScreenEvent();

  @override
  List<Object> get props => [];
}

class GetImagesEvent extends MainScreenEvent {
  const GetImagesEvent();
}

class LoadMoreImageEvent extends MainScreenEvent {
  const LoadMoreImageEvent();
}
