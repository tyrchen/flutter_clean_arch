import 'dart:ffi';

import 'package:clean_arch/core/core.dart';
import 'package:clean_arch/features/number_trivia/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/mocks.dart';

void main() {
  NumberTriviaRepositoryImpl repo;
  MockRemoteDataSource mockRemote;
  MockLocalDataSource mockLocal;
  MockNetworkInfo mockNet;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    mockNet = MockNetworkInfo();
    repo = NumberTriviaRepositoryImpl(
      remote: mockRemote,
      local: mockLocal,
      networkInfo: mockNet,
    );
  });

  void _runTest(Function body, {bool online = true}) {
    group('device is ${online ? "online" : "offline"}', () {
      setUp(() {
        when(mockNet.isConnected).thenAnswer((_) async => online);
      });
      body();
    });
  }

  void runTestOnline(Function body) => _runTest(body);
  void runTestOffline(Function body) => _runTest(body, online: false);

  group('getConcreteNumberTrivia', () {
    final n = 1;
    final model = NumberTriviaModel(number: n, text: 'test trvia');
    final NumberTrivia entity = model;
    test('should check if the device is online', () async {
      when(mockNet.isConnected).thenAnswer((_) async => true);
      repo.get(n);
      verify(mockNet.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is sucessful',
          () async {
        when(mockRemote.get(any)).thenAnswer((_) async => model);
        final result = await repo.get(n);
        verify(mockRemote.get(n));
        expect(result, Right(entity));
      });

      test(
          'should cache the data when the call to remote data source is sucessful',
          () async {
        when(mockRemote.get(any)).thenAnswer((_) async => model);
        await repo.get(n);
        verify(mockRemote.get(n));
        verify(mockLocal.cache(model));
      });
      test(
          'should return server failure when the call to remote data source is unsucessful',
          () async {
        when(mockRemote.get(any)).thenThrow(ServerException());
        final result = await repo.get(n);
        verify(mockRemote.get(n));
        verifyZeroInteractions(mockLocal);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocal.getLast()).thenAnswer((Dart_CObject) async => model);
          // act
          final result = await repo.get(n);

          // assert
          verifyZeroInteractions(mockRemote);
          verify(mockLocal.getLast());
          expect(result, Right(entity));
        },
      );

      test(
        'should return CacheFailure when the cached data is absent',
        () async {
          // arrange
          when(mockLocal.getLast()).thenThrow(CacheException());
          // act
          final result = await repo.get(n);

          // assert
          verifyZeroInteractions(mockRemote);
          verify(mockLocal.getLast());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    final model = NumberTriviaModel(number: 123, text: 'test trvia');
    final NumberTrivia entity = model;
    test('should check if the device is online', () async {
      when(mockNet.isConnected).thenAnswer((_) async => true);
      repo.getRandom();
      verify(mockNet.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is sucessful',
          () async {
        when(mockRemote.getRandom()).thenAnswer((_) async => model);
        final result = await repo.getRandom();
        verify(mockRemote.getRandom());
        expect(result, Right(entity));
      });

      test(
          'should cache the data when the call to remote data source is sucessful',
          () async {
        when(mockRemote.getRandom()).thenAnswer((_) async => model);
        await repo.getRandom();
        verify(mockRemote.getRandom());
        verify(mockLocal.cache(model));
      });
      test(
          'should return server failure when the call to remote data source is unsucessful',
          () async {
        when(mockRemote.getRandom()).thenThrow(ServerException());
        final result = await repo.getRandom();
        verify(mockRemote.getRandom());
        verifyZeroInteractions(mockLocal);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocal.getLast()).thenAnswer((_) async => model);
          // act
          final result = await repo.getRandom();

          // assert
          verifyZeroInteractions(mockRemote);
          verify(mockLocal.getLast());
          expect(result, Right(entity));
        },
      );

      test(
        'should return CacheFailure when the cached data is absent',
        () async {
          // arrange
          when(mockLocal.getLast()).thenThrow(CacheException());
          // act
          final result = await repo.getRandom();

          // assert
          verifyZeroInteractions(mockRemote);
          verify(mockLocal.getLast());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
