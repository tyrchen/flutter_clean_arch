import 'dart:convert';

import 'package:clean_arch/core/core.dart';
import 'package:clean_arch/features/number_trivia/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:http/http.dart' as http;

import '../../../../fixture/fixture_reader.dart';
import '../../../../fixture/mocks.dart';

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockClient;

  setUp(() {
    mockClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockClient);
  });

  final data = fixture('trivia.json');
  final _setupMock200 = () {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(data, 200));
  };

  final _setupMock500 = () {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 500));
  };

  final _getHeader = () => {
        'Content-Type': 'application/json',
      };
  group('getConcreteNumberTrivia', () {
    final n = 1;

    final model = NumberTriviaModel.fromJson(json.decode(data));
    test('''should perform a GET request on a URL with number
          being the endpoint and application/json header''', () async {
      // arrange
      _setupMock200();
      // act
      dataSource.get(n);

      // assert
      verify(mockClient.get(
        'http://numbersapi.com/$n',
        headers: _getHeader(),
      ));
    });
    test('should return NumberTrivia when the respond code is 200 (success)',
        () async {
      // arrange
      _setupMock200();
      // act
      final result = await dataSource.get(n);
      // assert
      expect(result, model);
    });

    test('should throw a server exception when the response code is not 200',
        () async {
      // arrange
      _setupMock500();
      // act
      // assert
      expect(() => dataSource.get(n), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final model = NumberTriviaModel.fromJson(json.decode(data));
    test('''should perform a GET request on a URL with number
          being the endpoint and application/json header''', () async {
      // arrange
      _setupMock200();
      // act
      dataSource.getRandom();

      // assert
      verify(mockClient.get(
        'http://numbersapi.com/random',
        headers: _getHeader(),
      ));
    });
    test('should return NumberTrivia when the respond code is 200 (success)',
        () async {
      // arrange
      _setupMock200();
      // act
      final result = await dataSource.getRandom();
      // assert
      expect(result, model);
    });

    test('should throw a server exception when the response code is not 200',
        () async {
      // arrange
      _setupMock500();
      // act
      // assert
      expect(() => dataSource.getRandom(),
          throwsA(TypeMatcher<ServerException>()));
    });
  });
}
