import 'package:clean_arch/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_arch/features/number_trivia/number_trivia.dart';

import 'package:clean_arch/core/tests/tests.dart';

void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockRepo;
  setUp(() {
    mockRepo = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockRepo);
  });

  final trivia = NumberTrivia(number: 1, text: 'test');

  test('should get trivia from the repository', () async {
    // arrange
    when(mockRepo.getRandom()).thenAnswer((_) async => Right(trivia));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, Right(trivia));
    verify(mockRepo.getRandom());
    verifyNoMoreInteractions(mockRepo);
  });
}
