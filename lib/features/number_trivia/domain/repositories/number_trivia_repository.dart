import 'package:clean_arch/core/core.dart';
import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> get(int number);
  Future<Either<Failure, NumberTrivia>> getRandom();
}
