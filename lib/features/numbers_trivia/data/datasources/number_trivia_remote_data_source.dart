import 'dart:convert';

import '../../../../core/error/exceptions.dart';

import '../models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

const API_URL = 'http://numbersapi.com';

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl('$API_URL/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUrl('$API_URL/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final uri = Uri.parse(url);
    final response =
        await client.get(uri, headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200) {
      throw ServerException();
    }
    return NumberTriviaModel.fromJson(json.decode(response.body));
  }
}
