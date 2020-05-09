import 'package:clean_arch/core/core.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsigned(String str) {
    try {
      final result = int.parse(str);
      if (result < 0) throw FormatException();
      return Right(result);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  String toString() => 'InvalidInputFailure';

  @override
  List<Object> get props => [toString()];
}
