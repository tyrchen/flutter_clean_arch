import 'dart:convert';

import 'package:clean_arch/core/core.dart';
import 'package:clean_arch/features/number_trivia/number_trivia.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> get(int number);
  Future<NumberTriviaModel> getRandom();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTriviaModel> get(int number) =>
      _get('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandom() => _get('http://numbersapi.com/random');

  Future<NumberTriviaModel> _get(String url) async {
    final response = await client.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200)
      return NumberTriviaModel.fromJson(json.decode(response.body));
    throw ServerException();
  }
}
