part of 'main_screen_bloc.dart';

class MainScreenState extends Equatable {
  const MainScreenState({
    this.imageList = const [],
  });

  final List<Hits> imageList;

  MainScreenState copyWith({
    List<Hits>? imageList,
  }) {
    return MainScreenState(
      imageList: imageList ?? this.imageList,
    );
  }

  @override
  List<Object> get props => [
        imageList,
      ];
}
