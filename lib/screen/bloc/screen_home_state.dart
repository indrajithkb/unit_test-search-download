part of 'screen_home_bloc.dart';

 class ScreenHomeState extends Equatable {
  const ScreenHomeState();

  @override
  List<Object> get props => [];
}

class ScreenHomeLoadingState extends ScreenHomeState {
  @override
  List<Object> get props => [];
}

class ScreenHomeLoadedState extends ScreenHomeState {
  ScreenHomeLoadedState(this.user);
  UserModel user;

  @override
  List<Object> get props => [user];
}

class ScreenHomeErrorState extends ScreenHomeState {
  ScreenHomeErrorState(this.error);
  String error;
  @override
  List<Object> get props => [error];
}
