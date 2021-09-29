import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/core/util/input_converter.dart';

void main() {
  late InputConverter converter;
  setUp(() {
    converter = InputConverter();
  });
  group('stringToUnsignedInt', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () async {
      // arrange
      final str = '123';
      // act
      final result = converter.stringToUnsignedInteger(str);
      // assert
      expect(result, Right(123));
    });
    test(
        'should return an InvalidInputFailure when the string cannot be parsed to integer',
        () async {
      // arrange
      final str = 'arroz';
      // act
      final result = converter.stringToUnsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });
    test(
        'should return an InvalidInputFailure when the string is a negativa integer',
        () async {
      // arrange
      final str = '-1';
      // act
      final result = converter.stringToUnsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
