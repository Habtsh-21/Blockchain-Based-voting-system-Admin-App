import 'package:blockchain_based_national_election_admin_app/core/failure/failure.dart';
import 'package:dartz/dartz.dart';
// import 'package:firebase_auth/firebase_auth.dart';

typedef AdminData = Future<Either<Failure, Unit>>;
typedef AdminUnit = Future<Either<Failure, Unit>>;
