import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_arch/features/number_trivia/number_trivia.dart';

import '../../../../fixture/mocks.dart';

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
    final result = await usecase(Params(number: n));
    // assert
    expect(result, Right(trivia));
    verify(mockRepo.get(n));
    verifyNoMoreInteractions(mockRepo);
  });
}
