import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../number_trivia.dart';

part 'number_trivial_event.dart';
part 'number_trivial_state.dart';

class NumberTrivialBloc extends Bloc<NumberTrivialEvent, NumberTrivialState> {
  @override
  NumberTrivialState get initialState => Empty();

  @override
  Stream<NumberTrivialState> mapEventToState(
    NumberTrivialEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
