import 'package:blockchain_based_national_election_admin_app/core/failure/failure.dart';
import 'package:blockchain_based_national_election_admin_app/core/network/network.dart';
import 'package:blockchain_based_national_election_admin_app/core/string/string.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/data_source/remote_contract_data_source.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/repo_impl/contract_repo_impl.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/party_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/representative_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/state_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/repository/contract_repository.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/add_party_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/add_rep_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/add_state_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/delete_rep_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/delete_state_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/detete_party_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/get_party_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/get_rep_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/usecase/get_state_usecase.dart';
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
final addRepProvider = Provider<AddRepUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return AddRepUsecase(contractRepository: contractRepo);
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

final deleteRepProvider = Provider<DeleteRepUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return DeleteRepUsecase(contractRepository: contractRepo);
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

final getRepProvider = Provider<GetRepUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return GetRepUsecase(contractRepository: contractRepo);
  },
);



class ContractNotifier extends StateNotifier<ContractProviderState> {
  final AddPartyUsecase addPartyUsecase;
  final AddStateUsecase addStateUsecase;
  final AddRepUsecase addRepUsecase;
  final DeletePartyUsecase deletePartyUsecase;
  final DeleteStateUsecase deleteStateUsecase;
  final DeleteRepUsecase deleteRepUsecase;
  final GetPartyUsecase getPartyUsecase;
  final GetStateUsecase getStateUsecase;
  final GetRepUsecase getRepUsecase;
  ContractNotifier({
    required this.addPartyUsecase,
    required this.addStateUsecase,
    required this.addRepUsecase,
    required this.deletePartyUsecase,
    required this.deleteStateUsecase,
    required this.deleteRepUsecase,
    required this.getPartyUsecase,
    required this.getStateUsecase,
    required this.getRepUsecase,
  }) : super(ContractInitialState());

  Future<void> addParty(
      String partyName, String partySymbol, int partyId) async {
    state = PartyAddingState();

    final result = await addPartyUsecase(PartyEntity(
        partyName: partyName, partySymbol: partySymbol, partyId: partyId));
    state = stateChecker(result, PartyAddedState());
  }

  Future<void> addState(String stateName, int stateId) async {
    state = StateAddingState();

    final result = await addStateUsecase(
        StateEntity(stateName: stateName, stateId: stateId));
    state = stateChecker(result, StateAddedState());
  }

  Future<void> addRep(String repName, String repPhoto, PartyEntity repParty,
      StateEntity repState) async {
    state = RepAddingState();

    final result = await addRepUsecase(RepresentativeEntity(
        repName: repName,
        repPhoto: repPhoto,
        party: repParty,
        state: repState));
    state = stateChecker(result, RepAddedState());
  }

  Future<void> deleteParty(int partyId) async {
    state = PartyDeletingState();

    final result = await deletePartyUsecase(partyId);
    state = stateChecker(result, PartyDeletedState());
  }

  Future<void> deleteState(int stateId) async {
    state = StateDeletingState();

    final result = await deleteStateUsecase(stateId);
    state = stateChecker(result, StateDeletedState());
  }

  Future<void> deleteRep(int partyId, int stateId) async {
    state = RepDeletingState();

    final result = await deleteRepUsecase(partyId, stateId);
    state = stateChecker(result, RepDeletedState());
  }

  Future<void> getParties() async {
    state = PartyFetchingState();

    final result = await getPartyUsecase();
    state = stateChecker(result, PartyFetchedState());
  }

  Future<void> getStates() async {
    state = StateFetchingState();

    final result = await getStateUsecase();
    state = stateChecker(result, StateFetchedState());
  }

  Future<void> getReps() async {
    state = RepFetchingState();

    final result = await getRepUsecase();
    state = stateChecker(result, RepFetchedState());
  }
}

final contractProvider =
    StateNotifierProvider<ContractNotifier, ContractProviderState>(
  (ref) {
    final addPartyUsecase = ref.watch(addPartyProvider);
    final addStateUsecase = ref.watch(addStateProvider);
    final addRepUsecase = ref.watch(addRepProvider);
    final deletePartyUsecase = ref.watch(deletePartyProvider);
    final deleteStateUsecase = ref.watch(deleteStateProvider);
    final deleteRepUsecase = ref.watch(deleteRepProvider);
    final getPartyUsecase = ref.watch(getPartyProvider);
    final getStateUsecase = ref.watch(getStateProvider);
    final getRepUsecase = ref.watch(getRepProvider);
    return ContractNotifier(
      addPartyUsecase: addPartyUsecase,
      addStateUsecase: addStateUsecase,
      addRepUsecase: addRepUsecase,
      deletePartyUsecase: deletePartyUsecase,
      deleteStateUsecase: deleteStateUsecase,
      deleteRepUsecase: deleteRepUsecase,
      getPartyUsecase: getPartyUsecase,
      getStateUsecase: getStateUsecase,
      getRepUsecase: getRepUsecase,
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
      return TRANSACTION_FAILED;
    default:
      return "Unexpected Error , Please try again later .";
  }
}
