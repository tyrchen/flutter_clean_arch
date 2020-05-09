import 'dart:convert';

import 'package:clean_arch/core/core.dart';
import 'package:clean_arch/features/number_trivia/number_trivia.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<void> cache(NumberTriviaModel model);

  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection
  ///
  /// Throws [CacheException] if no cached data is present
  Future<NumberTriviaModel> getLast();
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cache(NumberTriviaModel model) {
    return sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA,
      json.encode(model.toJson()),
    );
  }

  @override
  Future<NumberTriviaModel> getLast() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    }
    throw CacheException();
  }
}
