import 'package:blockchain_based_national_election_admin_app/core/failure/failure.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/rep_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/state_model.dart';
import 'package:dartz/dartz.dart';
// import 'package:firebase_auth/firebase_auth.dart';

typedef AdminData = Future<Either<Failure, Unit>>;
typedef AdminUnit = Future<Either<Failure, Unit>>;
typedef ContractData = Future<Either<Failure, String>>;
typedef ContractRepList = Future<Either<Failure, List<RepresentativeModel>>>;
typedef ContractPartyList = Future<Either<Failure, List<PartyModel>>>;
typedef ContractStateList = Future<Either<Failure, List<StateModel>>>;