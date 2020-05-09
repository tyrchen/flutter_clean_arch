part of 'number_trivial_bloc.dart';

abstract class NumberTrivialState extends Equatable {
  const NumberTrivialState();

  @override
  List<Object> get props => [];
}

class Empty extends NumberTrivialState {}

class Loading extends NumberTrivialState {}

class Loaded extends NumberTrivialState {
  final NumberTrivia trivia;

  Loaded({@required this.trivia});

  @override
  List<Object> get props => [trivia];
}

class Error extends NumberTrivialState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
