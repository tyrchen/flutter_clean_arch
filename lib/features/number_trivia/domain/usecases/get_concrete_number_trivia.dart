import 'package:meta/meta.dart';

import 'package:clean_arch/core/error/failure.dart';
import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repo;

  GetConcreteNumberTrivia(this.repo);

  Future<Either<Failure, NumberTrivia>> execute({@required int number}) async {
    return await repo.get(number);
  }
}
