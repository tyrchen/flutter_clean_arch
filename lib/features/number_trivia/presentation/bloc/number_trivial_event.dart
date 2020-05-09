part of 'number_trivial_bloc.dart';

abstract class NumberTrivialEvent extends Equatable {
  const NumberTrivialEvent();
}

class GetTriviaForConcreteNumber extends NumberTrivialEvent {
  final String numberString;

  GetTriviaForConcreteNumber(this.numberString);

  @override
  List<Object> get props => [numberString];
}

class GetTriviaForRandomNumber extends NumberTrivialEvent {
  @override
  List<Object> get props => [];
}
