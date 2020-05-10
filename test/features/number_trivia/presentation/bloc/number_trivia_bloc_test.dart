import 'package:clean_arch/core/core.dart';
import 'package:clean_arch/features/number_trivia/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/mocks.dart';

void main() {
  NumberTrivialBloc bloc;
  MockGetConcreteNumberTrivia mockConcrete;
  MockGetRandomNumberTrivia mockRandom;
  MockInputConverter mockConverter;

  setUp(() {
    mockConcrete = MockGetConcreteNumberTrivia();
    mockRandom = MockGetRandomNumberTrivia();
    mockConverter = MockInputConverter();
    bloc = NumberTrivialBloc(
      concrete: mockConcrete,
      random: mockRandom,
      converter: mockConverter,
    );
  });

  test('initialState should be Empty', () {
    expect(bloc.initialState, Empty());
  });

  group('GetTriviaForConcreteNumber', () {
    final numStr = '1';
    final n = 1;
    final entity = NumberTrivia(number: 1, text: 'test trivia');

    test(
        'should call the InputConverter to validate and convert the string to an unsiged integer',
        () async {
      // arrange
      when(mockConverter.stringToUnsigned(any)).thenReturn(Right(n));
      // act
      bloc.add(GetTriviaForConcreteNumber(numStr));
      await untilCalled(mockConverter.stringToUnsigned(any));
      // assert
      verify(mockConverter.stringToUnsigned(numStr));
    });

    blocTest(
      'should emilt [Error] when input is invalid',
      build: () async {
        when(mockConverter.stringToUnsigned(any))
            .thenReturn(Left(InvalidInputFailure()));
        return bloc;
      },
      act: (bloc) async => bloc.add(GetTriviaForConcreteNumber(numStr)),
      expect: [Error(message: INVALID_INPUT_FAILURE_MSG)],
    );
  });
}
