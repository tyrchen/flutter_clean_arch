import 'package:clean_arch/features/number_trivia/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> get(int number);
  Future<NumberTriviaModel> getRandom();
}
