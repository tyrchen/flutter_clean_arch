import 'package:clean_arch/core/core.dart';
import 'package:clean_arch/features/number_trivia/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/mocks.dart';

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockConcrete;
  MockGetRandomNumberTrivia mockRandom;
  MockInputConverter mockConverter;

  setUp(() {
    mockConcrete = MockGetConcreteNumberTrivia();
    mockRandom = MockGetRandomNumberTrivia();
    mockConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
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

    final setupMockConverterSuccess =
        () => when(mockConverter.stringToUnsigned(any)).thenReturn(Right(n));

    final setupMockConverterFail = () =>
        when(mockConverter.stringToUnsigned(any))
            .thenReturn(Left(InvalidInputFailure()));
    test(
        'should call the InputConverter to validate and convert the string to an unsiged integer',
        () async {
      // arrange
      setupMockConverterSuccess();
      // act
      bloc.add(GetTriviaForConcreteNumber(numStr));
      await untilCalled(mockConverter.stringToUnsigned(any));
      // assert
      verify(mockConverter.stringToUnsigned(numStr));
    });

    blocTest(
      'should emilt [Error] when input is invalid',
      build: () async {
        setupMockConverterFail();
        return bloc;
      },
      act: (bloc) async => bloc.add(GetTriviaForConcreteNumber(numStr)),
      expect: [Error(message: INVALID_INPUT_FAILURE_MSG)],
    );

    blocTest(
      'should get data from the concrete use case',
      build: () async {
        setupMockConverterSuccess();
        when(mockConcrete(any)).thenAnswer((_) async => Right(entity));
        return bloc;
      },
      act: (bloc) async => bloc.add(GetTriviaForConcreteNumber(numStr)),
      verify: (_bloc) {
        verify(mockConcrete(Params(number: n)));
        return;
      },
    );

    blocTest(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () async {
        setupMockConverterSuccess();
        when(mockConcrete(any)).thenAnswer((_) async => Right(entity));
        return bloc;
      },
      act: (bloc) async => bloc.add(GetTriviaForConcreteNumber(numStr)),
      expect: [Loading(), Loaded(trivia: entity)],
    );

    blocTest(
      'should emit [Loading, Error] when data fails',
      build: () async {
        setupMockConverterSuccess();
        when(mockConcrete(any)).thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) async => bloc.add(GetTriviaForConcreteNumber(numStr)),
      expect: [Loading(), Error(message: SERVER_FAILURE_MSG)],
    );

    blocTest(
      'should emit [Loading, Error] with proper message for the error',
      build: () async {
        setupMockConverterSuccess();
        when(mockConcrete(any)).thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) async => bloc.add(GetTriviaForConcreteNumber(numStr)),
      expect: [Loading(), Error(message: CACHE_FAILURE_MSG)],
    );
  });

  group('GetTriviaForRandomNumber', () {
    final entity = NumberTrivia(number: 1, text: 'test trivia');

    blocTest(
      'should get data from the random use case',
      build: () async {
        when(mockRandom(any)).thenAnswer((_) async => Right(entity));
        return bloc;
      },
      act: (bloc) async => bloc.add(GetTriviaForRandomNumber()),
      verify: (_bloc) {
        verify(mockRandom(NoParams()));
        return;
      },
    );

    blocTest(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () async {
        when(mockRandom(any)).thenAnswer((_) async => Right(entity));
        return bloc;
      },
      act: (bloc) async => bloc.add(GetTriviaForRandomNumber()),
      expect: [Loading(), Loaded(trivia: entity)],
    );

    blocTest(
      'should emit [Loading, Error] when data fails',
      build: () async {
        when(mockRandom(any)).thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) async => bloc.add(GetTriviaForRandomNumber()),
      expect: [Loading(), Error(message: SERVER_FAILURE_MSG)],
    );

    blocTest(
      'should emit [Loading, Error] with proper message for the error',
      build: () async {
        when(mockRandom(any)).thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) async => bloc.add(GetTriviaForRandomNumber()),
      expect: [Loading(), Error(message: CACHE_FAILURE_MSG)],
    );
  });
}
