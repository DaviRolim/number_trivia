import 'package:dartz/dartz.dart';
import '../error/failures.dart';

abstract class UseCaseWithoutParams<Type> {
  Future<Either<Failure, Type>> call();
}
