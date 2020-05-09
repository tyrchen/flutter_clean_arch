import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arch/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockRepo;
  setUp(() {
    mockRepo = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockRepo);
  });

  final n = 1;
  final trivia = NumberTrivia(number: 1, text: 'test');

  test('should get trivia for the number from the repository', () async {
    // arrange
    when(mockRepo.get(any)).thenAnswer((_) async => Right(trivia));
    // act
    final result = await usecase.execute(number: n);
    // assert
    expect(result, Right(trivia));
    verify(mockRepo.get(n));
    verifyNoMoreInteractions(mockRepo);
  });
}
