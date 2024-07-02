import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone_new/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>; 
typedef FutureVoid = FutureEither<void>;