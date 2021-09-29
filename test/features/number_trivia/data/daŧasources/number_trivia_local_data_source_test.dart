import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/core/error/exceptions.dart';
import 'package:numbers_trivia/features/numbers_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:numbers_trivia/features/numbers_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });
  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));
      // act
      final result = await dataSource.getLastNumberTrivia();
      // assert
      verify((mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA)));
      expect(result, equals(tNumberTriviaModel));
    });
    test('should return CacheFailure when there is nothing in the cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenThrow(Exception());
      // act
      final call = dataSource.getLastNumberTrivia;
      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });
  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test trivia');
    test('should call SharedPreferences to cache the data', () async {
      // act
      await dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      final expectedString = json.encode(tNumberTriviaModel.toJson());
      verify(
        (mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedString)),
      );
    });
  });
}
