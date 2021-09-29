import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:numbers_trivia/features/numbers_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/features/numbers_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia/features/numbers_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia usecase;
  var mockNumberTriviaRepository = MockNumberTriviaRepository();
  setUp(() {
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: 'test1');
  test('should get trivia from the repository', () async {
    // arrange
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));
    // act
    final result = await usecase();
    // assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
  });
}
