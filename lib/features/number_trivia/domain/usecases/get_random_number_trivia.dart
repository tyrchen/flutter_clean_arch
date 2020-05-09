import 'package:clean_arch/core/core.dart';
import 'package:clean_arch/features/number_trivia/number_trivia.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repo;

  GetRandomNumberTrivia(this.repo);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repo.getRandom();
  }
}
