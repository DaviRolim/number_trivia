import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:numbers_trivia/core/error/exceptions.dart';
import 'package:numbers_trivia/features/numbers_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:numbers_trivia/features/numbers_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHTTPClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHTTPClient mockHTTPclient;

  setUp(() {
    mockHTTPclient = MockHTTPClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHTTPclient);
  });
  void setUpMockHttpClient({url, statusCode}) {
    when(mockHTTPclient.get(Uri.parse(url), headers: anyNamed('headers')))
        .thenAnswer(
            (_) async => http.Response(fixture('trivia.json'), statusCode));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final apiUrl = API_URL;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        'should perform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
      // arrange
      setUpMockHttpClient(url: '$apiUrl/$tNumber', statusCode: 200);
      // act
      dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(
        mockHTTPclient.get(Uri.parse('$apiUrl/$tNumber'),
            headers: {'Content-Type': 'application/json'}),
      );
    });
    test('should return NumberTrivial when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClient(url: '$apiUrl/$tNumber', statusCode: 200);
      // act
      final response = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(response, equals(tNumberTriviaModel));
    });
    test(
        'should return ServerException when the response code is not 200 (success)',
        () async {
      // arrange
      setUpMockHttpClient(url: '$apiUrl/$tNumber', statusCode: 404);
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });
  group('getRandomNumberTrivia', () {
    final apiUrl = API_URL;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        'should perform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
      // arrange
      setUpMockHttpClient(url: '$apiUrl/random', statusCode: 200);
      // act
      dataSource.getRandomNumberTrivia();
      // assert
      verify(
        mockHTTPclient.get(Uri.parse('$apiUrl/random'),
            headers: {'Content-Type': 'application/json'}),
      );
    });
    test('should return NumberTrivial when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClient(url: '$apiUrl/random', statusCode: 200);
      // act
      final response = await dataSource.getRandomNumberTrivia();
      // assert
      expect(response, equals(tNumberTriviaModel));
    });
    test(
        'should return ServerException when the response code is not 200 (success)',
        () async {
      // arrange
      setUpMockHttpClient(url: '$apiUrl/random', statusCode: 404);
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
