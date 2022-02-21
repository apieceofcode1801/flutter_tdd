import 'package:dartz/dartz.dart';
import 'package:flutter_tdd/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    final result = int.tryParse(str);
    if (result != null && result >= 0) {
      return Right(result);
    } else {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
