import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/core/util/input_converter.dart';
import 'package:numbers_trivia/features/numbers_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/numbers_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia/features/numbers_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbers_trivia/features/numbers_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initalState should be Empty', () async {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverter({required bool success}) {
      if (success) {
        when(mockInputConverter.stringToUnsignedInteger(tNumberString))
            .thenReturn(Right(tNumberParsed));
      } else {
        when(mockInputConverter.stringToUnsignedInteger(tNumberString))
            .thenReturn(Left(InvalidInputFailure()));
      }
    }

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      // arrange
      setUpMockInputConverter(success: true);
      when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(
          mockInputConverter.stringToUnsignedInteger(tNumberString));
      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emit [Error] when the input is invalid',
      build: () {
        setUpMockInputConverter(success: false);
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () =>
          <NumberTriviaState>[Error(message: INVALID_INPUT_FAILURE_MESSAGE)],
    );
    test('should get adata from the concrete use case', () async {
      // arrange
      setUpMockInputConverter(success: true);
      when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(
          mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      // assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        setUpMockInputConverter(success: true);
        when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Right(tNumberTrivia));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () =>
          <NumberTriviaState>[Loading(), Loaded(trivia: tNumberTrivia)],
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emit [Loading, Error] when getting data fails',
      build: () {
        setUpMockInputConverter(success: true);
        when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () {
        setUpMockInputConverter(success: true);
        when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () =>
          <NumberTriviaState>[Loading(), Error(message: CACHE_FAILURE_MESSAGE)],
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');
    test('should get adata from the concrete use case', () async {
      // arrange
      when(mockGetRandomNumberTrivia())
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia());
      // assert
      verify(mockGetRandomNumberTrivia());
    });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetRandomNumberTrivia())
            .thenAnswer((_) async => Right(tNumberTrivia));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () =>
          <NumberTriviaState>[Loading(), Loaded(trivia: tNumberTrivia)],
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emit [Loading, Error] when getting data fails',
      build: () {
        when(mockGetRandomNumberTrivia())
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () {
        when(mockGetRandomNumberTrivia())
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () =>
          <NumberTriviaState>[Loading(), Error(message: CACHE_FAILURE_MESSAGE)],
    );
  });
}
