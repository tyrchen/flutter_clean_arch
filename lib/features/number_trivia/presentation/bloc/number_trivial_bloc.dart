import 'dart:async';
import 'package:clean_arch/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../number_trivia.dart';

part 'number_trivial_event.dart';
part 'number_trivial_state.dart';

const String SERVER_FAILURE_MSG = 'Server Failure';
const String CACHE_FAILURE_MSG = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MSG =
    'Invalid input - the number must be a positive integer or zero';

typedef Future<Either<Failure, NumberTrivia>> _GetResult();

class NumberTrivialBloc extends Bloc<NumberTrivialEvent, NumberTrivialState> {
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;
  final InputConverter converter;

  NumberTrivialBloc({
    @required this.concrete,
    @required this.random,
    @required this.converter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(converter != null);
  @override
  NumberTrivialState get initialState => Empty();

  @override
  Stream<NumberTrivialState> mapEventToState(
    NumberTrivialEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final converted = converter.stringToUnsigned(event.numberString);
      yield* converted.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MSG);
        },
        (n) async* {
          yield* _loadData(() => concrete(Params(number: n)));
        },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield* _loadData(() => random(NoParams()));
    }
  }

  Stream<NumberTrivialState> _loadData(_GetResult getResult) async* {
    yield Loading();
    final result = await getResult();

    yield result.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (r) => Loaded(trivia: r),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MSG;
      case CacheFailure:
        return CACHE_FAILURE_MSG;
      default:
        return 'Unexpected error';
    }
  }
}
