import 'package:blockchain_based_national_election_admin_app/core/exception/exception.dart';
import 'package:blockchain_based_national_election_admin_app/core/failure/failure.dart';
import 'package:blockchain_based_national_election_admin_app/core/network/network.dart';
import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/data/data_source/remote_data_source.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/data/model/admin_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/domain/entities/admin_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/domain/repository/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImplementation extends AuthRepository {
  RemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;

  AuthRepoImplementation(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  AdminUnit logIn(AdminEntity adminEntity) async {
    if (await networkInfo.isConnected) {
      try {
        AdminModel adminModel = AdminModel(
          email: adminEntity.email,
          password: adminEntity.password,
        );
        await remoteDataSource.logIn(adminModel);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      } on UserNotFoundException {
        return Left(UserNotFoundFailure());
      } on WrongPasswordException {
        return Left(WrongPasswordFailure());
      } on InvalidEmailException {
        return Left(InvalidEmailFailure());
      } on UserDisableException {
        return Left(UserDisabledFailure());
      } on EmailAlreadyInUseException {
        return Left(EmailAlreadyInUseFailure());
      } on OperationNotAllowedException {
        return Left(OperationNotAllowedFailure());
      } on TooManyRequestsException {
        return Left(TooManyRequestsFailure());
      } catch (e) {
        if (e is TransactionFailedException) {
          return Left(TransactionFailedFailure(message: e.message));
        } else{
           return Left(ServerFailure());
        }
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  AdminUnit logOut() async {
    try {
      await remoteDataSource.logOut();
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  AdminData usersData({int atmp = 1}) async {
    int maxAtmp = 10;
    if (await networkInfo.isConnected) {
      try {
        int result = await remoteDataSource.usersData();
        return Right(result);
      } catch (e) {
        if (e is TransactionFailedException) {
          return Left(TransactionFailedFailure(message: e.message));
        } else {
          return Left(ServerFailure());
        }
      }
    } else {
      if (atmp < maxAtmp) {
        Future.delayed(
          const Duration(seconds: 3),
          () => usersData(atmp: atmp + 1),
        );
      }
      return Left(OfflineFailure());
    }
  }
}
