import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sampleapi/model/user_model.dart';
import 'package:sampleapi/repo/repository.dart';

part 'screen_home_event.dart';
part 'screen_home_state.dart';

class ScreenHomeBloc extends Bloc<ScreenHomeEvent, ScreenHomeState> {
  final UserRepo _userRepo;
  ScreenHomeBloc(this._userRepo) : super(ScreenHomeLoadingState()) {
    on<LoadScreenHomeEvent>(_onLoadScreenHomeEvent);
  }

  FutureOr<void> _onLoadScreenHomeEvent(
      LoadScreenHomeEvent event, Emitter<ScreenHomeState> emit) async {
    emit(ScreenHomeLoadingState());
    try {
      final UserModel user = await _userRepo.getApiData();

      emit(ScreenHomeLoadedState(user));
    } catch (e) {
      emit(ScreenHomeErrorState(e.toString()));
    }
  }
}
