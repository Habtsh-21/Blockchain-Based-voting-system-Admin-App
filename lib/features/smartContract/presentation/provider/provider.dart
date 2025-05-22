import 'dart:io';

import 'package:blockchain_based_national_election_admin_app/core/failure/failure.dart';
import 'package:blockchain_based_national_election_admin_app/core/network/network.dart';
import 'package:blockchain_based_national_election_admin_app/core/string/string.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/data_source/remote_contract_data_source.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/all_data_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/state_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/repo_impl/contract_repo_impl.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/party_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/state_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/repository/contract_repository.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/add_party_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/add_state_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/delete_state_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/detete_party_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/get_all_data_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/get_party_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/get_state_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/pause_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/set_time_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/uploadImage_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final connectionProvider = Provider<InternetConnection>(
  (ref) => InternetConnection(),
);
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final connectionChecker = ref.watch(connectionProvider);
  return NetworkInfoImpl(connectionChecker);
});

final remoteContractDataSourceProvider = Provider<RemoteContractDataSource>(
  (ref) => RemoteContractDataSourceImpl(),
);

final contractRepoProvider = Provider<ContractRepository>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  final remoteContract = ref.watch(remoteContractDataSourceProvider);
  return ContractRepoImpl(
      networkInfo: networkInfo, remoteContractDataSource: remoteContract);
});

final addPartyProvider = Provider<AddPartyUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return AddPartyUsecase(contractRepository: contractRepo);
  },
);
final addStateProvider = Provider<AddStateUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return AddStateUsecase(contractRepository: contractRepo);
  },
);

final deletePartyProvider = Provider<DeletePartyUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return DeletePartyUsecase(contractRepository: contractRepo);
  },
);
final deleteStateProvider = Provider<DeleteStateUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return DeleteStateUsecase(contractRepository: contractRepo);
  },
);

final getPartyProvider = Provider<GetPartyUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return GetPartyUsecase(contractRepository: contractRepo);
  },
);
final getStateProvider = Provider<GetStateUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return GetStateUsecase(contractRepository: contractRepo);
  },
);
final getAllDataProver = Provider<GetAllDataUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return GetAllDataUsecase(contractRepository: contractRepo);
  },
);
final getUploadedUrl = Provider<UploadimageUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return UploadimageUsecase(contractRepository: contractRepo);
  },
);

final setTimeProver = Provider<SetTimeUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return SetTimeUsecase(contractRepository: contractRepo);
  },
);
final pauseProvider = Provider<PauseUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return PauseUsecase(contractRepository: contractRepo);
  },
);

class ContractNotifier extends StateNotifier<ContractProviderState> {
  final AddPartyUsecase addPartyUsecase;
  final AddStateUsecase addStateUsecase;

  final DeletePartyUsecase deletePartyUsecase;
  final DeleteStateUsecase deleteStateUsecase;

  final GetPartyUsecase getPartyUsecase;
  final GetStateUsecase getStateUsecase;

  final GetAllDataUsecase getAllDataUsecase;
  final UploadimageUsecase uploadimageUsecase;

  final SetTimeUsecase setTimeUsecase;
  final PauseUsecase pauseUsecase;

  ContractNotifier({
    required this.addPartyUsecase,
    required this.addStateUsecase,
    required this.deletePartyUsecase,
    required this.deleteStateUsecase,
    required this.getPartyUsecase,
    required this.getStateUsecase,
    required this.getAllDataUsecase,
    required this.uploadimageUsecase,
    required this.setTimeUsecase,
    required this.pauseUsecase,
  }) : super(ContractInitialState());

  List<PartyModel>? partyList;
  List<StateModel>? stateList;
  int totalVote = 0;
  bool _isVotingActive = false;
  bool _isVotingPaused = false;
  int _totalNoOfParties = 0;
  int _totalNoOfStates = 0;
  int _startTime = 0;
  int _endTime = 0;

  String? fileUrl;
  int counter = 0;
  void initialize() async {
    partyList = await fatchParties();
    stateList = await fatchStates();
  }

  void parties() async {
    partyList = await fatchParties();
  }

  void states() async {
    stateList = await fatchStates();
  }

  Future<void> addParty(
      String partyName, String partySymbol, int partyId) async {
    state = PartyAddingState();

    final result = await addPartyUsecase(PartyEntity(
        partyName: partyName, partySymbol: partySymbol, partyId: partyId));
    state = result.fold(
        (l) => ContractFailureState(message: _mapFailureToMessage(l)), (r) {
      return PartyAddedState(trxHash: r);
    });
    Future.delayed(const Duration(seconds: 2), () => resetState());
  }

  Future<void> addState(String stateName, int stateId) async {
    state = StateAddingState();

    final result = await addStateUsecase(
        StateEntity(stateName: stateName, stateId: stateId));
    state = result.fold(
        (l) => ContractFailureState(message: _mapFailureToMessage(l)), (r) {
      return StateAddedState(trxHash: r);
    });
    Future.delayed(const Duration(seconds: 2), () => resetState());
  }

  Future<void> deleteParty(int partyId) async {
    state = PartyDeletingState();

    final result = await deletePartyUsecase(partyId);
    state = result.fold(
        (l) => ContractFailureState(message: _mapFailureToMessage(l)), (r) {
      return PartyDeletedState(txHash: r);
    });
    Future.delayed(const Duration(seconds: 2), () => resetState());
  }

  Future<void> deleteState(int stateId) async {
    state = StateDeletingState();

    final result = await deleteStateUsecase(stateId);
    state = result.fold(
        (l) => ContractFailureState(message: _mapFailureToMessage(l)), (r) {
      return StateDeletedState(txHash: r);
    });
    Future.delayed(const Duration(seconds: 2), () => resetState());
  }

  Future<List<PartyModel>?> fatchParties() async {
    state = PartyFetchingState();
    final result = await getPartyUsecase();
    state = result.fold((l) {
      return ContractFailureState(message: _mapFailureToMessage(l));
    }, (r) {
      partyList = r;
      return PartyFetchedState(partiesList: r);
    });

    Future.delayed(const Duration(seconds: 2), () => resetState());
    return partyList;
  }

  Future<List<StateModel>?> fatchStates() async {
    state = StateFetchingState();

    final result = await getStateUsecase();
    state = result.fold(
        (l) => ContractFailureState(message: _mapFailureToMessage(l)), (r) {
      stateList = r;
      return StateFetchedState(stateList: r);
    });
    Future.delayed(const Duration(seconds: 2), () => resetState());
    return stateList;
  }

  Future<AllDataModel?> fatchAllData() async {
    AllDataModel? allDataModel;
    state = ContractAllDataFatchingState();
    final result = await getAllDataUsecase();
    state = result.fold(
        (l) => ContractFailureState(message: _mapFailureToMessage(l)), (r) {
      allDataModel = r;
      partyList = r.parties;
      stateList = r.states;
      _totalNoOfParties = partyList != null ? partyList!.length : 0;
      _totalNoOfStates = stateList != null ? stateList!.length : 0;
      _isVotingActive = r.isVotringActive;
      _isVotingPaused = r.votingPaused;
      _startTime = r.votingStateTime;
      _endTime = r.votingEndTime;
      return ContractAllDataFatchedState();
    });
    return allDataModel;
  }

  Future<String?> uploadImage(File pickedFile, String fileName) async {
    state = FileUpoadingState();
    final result = await uploadimageUsecase(pickedFile, fileName);
    state = result.fold(
      (l) => ContractFailureState(message: _mapFailureToMessage(l)),
      (r) {
        fileUrl = r;
        return FileUpoadedState();
      },
    );
    Future.delayed(const Duration(seconds: 2), () => resetState());
    return fileUrl;
  }

  List<PartyModel>? getParties() {
    return partyList;
  }

  List<StateModel>? getStates() {
    return stateList;
  }

  int getTotalNoOfParties() {
    return _totalNoOfParties;
  }

  int getTotalNoOfStates() {
    return _totalNoOfStates;
  }

  int getTotalVote() {
    return totalVote;
  }

  bool isVotingActive() {
    return _isVotingActive;
  }

  bool isVotingPaused() {
    return _isVotingPaused;
  }

  Future<void> pause(bool pause) async {
    state = VotePausingState();
    final result = await pauseUsecase(pause);
    state = result.fold(
      (l) => ContractFailureState(message: _mapFailureToMessage(l)),
      (r) {
        fileUrl = r;
        return VotePauseExcutedState(txHash: r);
      },
    );
  }

  DateTime? startTime() {
    if (_startTime == 0) return null;
    DateTime start = DateTime.fromMillisecondsSinceEpoch(_startTime * 1000);
    return start;
  }

  DateTime? endTime() {
    if (_endTime == 0) return null;
    DateTime end = DateTime.fromMillisecondsSinceEpoch(_endTime * 1000);
    return end;
  }

  Future<void> setTime(DateTime startTime, DateTime endTime) async {
    state = TimeSettingState();
    int startTimeInSeconds = startTime.millisecondsSinceEpoch ~/ 1000;
    int endTimeInSeconds = endTime.millisecondsSinceEpoch ~/ 1000;
    final result = await setTimeUsecase(startTimeInSeconds, endTimeInSeconds);
    state = result.fold(
      (l) => ContractFailureState(message: _mapFailureToMessage(l)),
      (r) {
        fileUrl = r;
        return TimeSettedState(message: r);
      },
    );
  }

  void resetState() {
    state = ContractInitialState();
  }

  void setFailure(ContractProviderState contractState) {
    state = contractState;
  }
}

final contractProvider =
    StateNotifierProvider<ContractNotifier, ContractProviderState>(
  (ref) {
    final addPartyUsecase = ref.watch(addPartyProvider);
    final addStateUsecase = ref.watch(addStateProvider);
    final deletePartyUsecase = ref.watch(deletePartyProvider);
    final deleteStateUsecase = ref.watch(deleteStateProvider);
    final getPartyUsecase = ref.watch(getPartyProvider);
    final getStateUsecase = ref.watch(getStateProvider);
    final getAllDataUsecase = ref.watch(getAllDataProver);
    final getFileUrl = ref.watch(getUploadedUrl);
    final setTimeUsecase = ref.watch(setTimeProver);
    final pauseUsecase = ref.watch(pauseProvider);

    return ContractNotifier(
      addPartyUsecase: addPartyUsecase,
      addStateUsecase: addStateUsecase,
      deletePartyUsecase: deletePartyUsecase,
      deleteStateUsecase: deleteStateUsecase,
      getPartyUsecase: getPartyUsecase,
      getStateUsecase: getStateUsecase,
      getAllDataUsecase: getAllDataUsecase,
      uploadimageUsecase: getFileUrl,
      setTimeUsecase: setTimeUsecase,
      pauseUsecase: pauseUsecase,
    );
  },
);

ContractProviderState stateChecker(
    Either either, ContractProviderState pState) {
  return either.fold(
      (failure) => ContractFailureState(message: _mapFailureToMessage(failure)),
      (r) => pState);
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case const (OfflineFailure):
      return OFFLINE_FAILURE_MESSAGE;
    case const (PartyAlreadyExistFailure):
      return PARTY_ALREADY_EXIST;
    case const (StateAlreadyExistFailure):
      return STATE_ALREADY_EXIST;
    case const (RepAlreadyExistFailure):
      return REP_ALREADY_EXIST;
    case const (TransactionFailedFailure):
      return (failure as TransactionFailedFailure).message;
    case const (SocketFailure):
      return SOCKET_FAILED;
    case const (StorageFailure):
      return STORAGE_MESSAGE;
    case const (ClientFailure):
      return CLIENT_FAILED;
    case const (NullValueFailure):
      return NULL_VALUE;
    case const (UnkownFailure):
      return UNKOWN_PROBLEM;
    default:
      return "Unexpected Error , Please try again later .";
  }
}
