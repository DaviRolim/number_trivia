import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases_no_params.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCaseWithoutParams<NumberTrivia> {
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call() async {
    return await repository.getRandomNumberTrivia();
  }
}
