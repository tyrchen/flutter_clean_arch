import 'dart:convert';

import 'package:clean_arch/core/core.dart';
import 'package:clean_arch/features/number_trivia/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../fixture/mocks.dart';

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockPref;

  setUp(() {
    mockPref = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockPref);
  });

  group('getLastNumberTrivia', () {
    final fixtureData = fixture('trivia_cached.json');
    final model = NumberTriviaModel.fromJson(json.decode(fixtureData));
    test(
        'should return NumberTrivia from SharedPreferences when there is one in cache',
        () async {
      // arrange
      when(mockPref.getString(any)).thenReturn(fixtureData);
      // act
      final result = await dataSource.getLast();
      // assert
      verify(mockPref.getString(CACHED_NUMBER_TRIVIA));
      expect(result, model);
    });

    test('should throw CacheException where there is no cached value',
        () async {
      // arrange
      when(mockPref.getString(any)).thenReturn(null);
      // act
      // assert
      expect(
          () => dataSource.getLast(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final model = NumberTriviaModel(number: 1, text: 'test trivia');
    test('should call SharedPreferences to cache the data', () async {
      // act
      dataSource.cache(model);
      // assert
      final expected = json.encode(model.toJson());
      verify(mockPref.setString(CACHED_NUMBER_TRIVIA, expected));
    });
  });
}
