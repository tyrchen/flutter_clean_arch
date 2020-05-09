import 'dart:convert';

import 'package:clean_arch/features/number_trivia/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  final model = NumberTriviaModel(number: 1, text: 'Test Text');

  test('should be a subclass of NumberTrivia entity', () async {
    expect(model, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer',
        () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, model);
    });

    test('should return a valid model when the JSON number is a double',
        () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, model);
    });
  });
  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final result = model.toJson();
      final expectedMap = {
        'text': model.text,
        'number': model.number,
      };
      expect(result, expectedMap);
    });
  });
}
