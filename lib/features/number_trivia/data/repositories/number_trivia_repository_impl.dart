import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';

import 'package:clean_arch/core/core.dart';
import 'package:clean_arch/features/number_trivia/number_trivia.dart';

typedef Future<NumberTrivia> _GetData();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remote;
  final NumberTriviaLocalDataSource local;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remote,
    @required this.local,
    @required this.networkInfo,
  });

  Future<Either<Failure, NumberTrivia>> _get(_GetData getData) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await getData();
        local.cache(model);
        return Right(model);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final model = await local.getLast();
        return Right(model);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> get(int number) async {
    return await _get(() {
      return remote.get(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandom() async {
    return await _get(() {
      return remote.getRandom();
    });
  }
}
