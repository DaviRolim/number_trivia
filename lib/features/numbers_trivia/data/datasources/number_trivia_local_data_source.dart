import 'dart:convert';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl(this.sharedPreferences);
  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    try {
      final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
      final numberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(jsonString));
      return Future.value(numberTriviaModel);
    } catch (Exception) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));
  }
}
