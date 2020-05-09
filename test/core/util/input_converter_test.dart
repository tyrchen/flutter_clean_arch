import 'package:clean_arch/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter converter;

  setUp(() {
    converter = InputConverter();
  });

  group('stringToUnsigned', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () async {
      // arrange
      final str = '123';
      // act
      final result = converter.stringToUnsigned(str);
      // assert
      expect(result, Right(123));
    });

    test('should return a Failure when the string is not an integer', () async {
      // arrange
      final str = 'abc';
      // act
      final result = converter.stringToUnsigned(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a Failure when the string is a negative integer',
        () async {
      // arrange
      final str = '-123';
      // act
      final result = converter.stringToUnsigned(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
