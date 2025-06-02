import 'dart:io';

import 'package:blockchain_based_national_election_admin_app/core/exception/exception.dart';
import 'package:blockchain_based_national_election_admin_app/core/failure/failure.dart';
import 'package:blockchain_based_national_election_admin_app/core/network/network.dart';
import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/data_source/remote_contract_data_source.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/state_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/party_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/state_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/repository/contract_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContractRepoImpl extends ContractRepository {
  final NetworkInfo networkInfo;
  final RemoteContractDataSource remoteContractDataSource;

  ContractRepoImpl(
      {required this.networkInfo, required this.remoteContractDataSource});

  @override
  ContractData addParty(PartyEntity partyEntity) async {
    if (await networkInfo.isConnected) {
      try {
        PartyModel partyModel = PartyModel(
            partyName: partyEntity.partyName,
            partySymbol: partyEntity.partySymbol,
            partyId: partyEntity.partyId);
        final txHash = await remoteContractDataSource.addParty(partyModel);
        return Right(txHash);
      } catch (e) {
        if (e is PartyAlreadyExistException) {
          return Left(RepAlreadyExistFailure());
        } else if (e is TransactionFailedException) {
          return Left(TransactionFailedFailure(message: e.message));
        } else {
          return Left(UnkownFailure());
        }
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  ContractData addState(StateEntity stateEntity) async {
    if (await networkInfo.isConnected) {
      try {
        StateModel stateModel = StateModel(
            stateName: stateEntity.stateName, stateId: stateEntity.stateId);
        final txHash = await remoteContractDataSource.addState(stateModel);
        return Right(txHash);
      } catch (e) {
        if (e is StateAlreadyExistException) {
          return Left(RepAlreadyExistFailure());
        } else if (e is TransactionFailedException) {
          return Left(TransactionFailedFailure(message: e.message));
        } else {
          return Left(UnkownFailure());
        }
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  ContractData deleteParty(int partyId) async {
    if (await networkInfo.isConnected) {
      try {
        final txHash = await remoteContractDataSource.deleteParty(partyId);
        return Right(txHash);
      } catch (e) {
        if (e is TransactionFailedException) {
          return Left(TransactionFailedFailure(message: e.message));
        } else {
          return Left(UnkownFailure());
        }
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  ContractData deleteState(int stateId) async {
    if (await networkInfo.isConnected) {
      try {
        final txHash = await remoteContractDataSource.deleteState(stateId);
        return Right(txHash);
      } catch (e) {
        if (e is TransactionFailedException) {
          return Left(TransactionFailedFailure(message: e.message));
        } else {
          return Left(UnkownFailure());
        }
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  ContractPartyList getParty() async {
    if (await networkInfo.isConnected) {
      try {
        final list = await remoteContractDataSource.getParties();
        return Right(list);
      } catch (e) {
        if (e is TransactionFailedException) {
          return Left(TransactionFailedFailure(message: e.message));
        } else {
          return Left(UnkownFailure());
        }
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  ContractStateList getState() async {
    if (await networkInfo.isConnected) {
      try {
        final list = await remoteContractDataSource.getState();
        return Right(list);
      } catch (e) {
        if (e is TransactionFailedException) {
          return Left(TransactionFailedFailure(message: e.message));
        } else {
          return Left(UnkownFailure());
        }
      }
    } else {
      return Left(OfflineFailure());
    }
  }
@override
ContractAllDta getAllData({int attempt = 1}) async {
  const maxAttempts = 10;

  if (await networkInfo.isConnected) {
    try {
      final data = await remoteContractDataSource.getAllData();
      return Right(data);
    } catch (e) {
      if (e is TransactionFailedException) {
        return Left(TransactionFailedFailure(message: e.message));
      } else {
        return Left(UnkownFailure());
      }
    }
  } else {
    if (attempt < maxAttempts) {
      await Future.delayed(const Duration(seconds: 3));
      return await getAllData( attempt: attempt + 1);
    } else {
      return Left(OfflineFailure());
    }
  }
}



  @override
  ContractData uploadImage(File pickedFile, String fileName) async {
    if (await networkInfo.isConnected) {
      try {
        final fileUrl =
            await remoteContractDataSource.uploadImage(pickedFile, fileName);
        return Right(fileUrl);
      } on StorageException {
        return Left(StorageFailure());
      } on SocketException {
        return Left(SocketFailure());
      } on ClientException {
        return Left(ClientFailure());
      } on NullPublicUrlException {
        return Left(NullValueFailure());
      } on UnknownException {
        return Left(UnkownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
  
  @override
  ContractData setTime(int startTime, int endTime) async {
     if (await networkInfo.isConnected) {
      try {
        final txHash = await remoteContractDataSource.setTime(startTime,endTime);
        return Right(txHash);
      } catch (e) {
        if (e is TransactionFailedException) {
          return Left(TransactionFailedFailure(message: e.message));
        } else {
          return Left(UnkownFailure());
        }
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  ContractData pause(bool pause) async {
     if (await networkInfo.isConnected) {
      try {
        final txHash = await remoteContractDataSource.pause(pause);
        return Right(txHash);
      } catch (e) {
        if (e is TransactionFailedException) {
          return Left(TransactionFailedFailure(message: e.message));
        } else {
          return Left(UnkownFailure());
        }
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
