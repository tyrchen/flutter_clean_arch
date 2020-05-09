import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:clean_arch/core/core.dart';
import 'package:clean_arch/features/number_trivia/number_trivia.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repo;

  // api.com/42?json
  // api.com/random?json

  GetConcreteNumberTrivia(this.repo);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repo.get(params.number);
  }
}

class Params extends Equatable {
  final int number;
  Params({@required this.number});

  @override
  List<Object> get props => [number];
}
