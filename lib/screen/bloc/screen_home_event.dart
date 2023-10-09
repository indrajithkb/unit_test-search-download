part of 'screen_home_bloc.dart';

sealed class ScreenHomeEvent extends Equatable {
  const ScreenHomeEvent();

  @override
  List<Object> get props => [];
}
class LoadScreenHomeEvent extends ScreenHomeEvent{
    @override
  List<Object> get props => [];
}

class fetchSearchList extends ScreenHomeEvent{
  Data datas;
  fetchSearchList(this.datas);
}