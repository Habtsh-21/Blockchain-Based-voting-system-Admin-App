import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/state_model.dart';
import 'package:equatable/equatable.dart';

abstract class ContractProviderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContractInitialState extends ContractProviderState {}

class ContractAllDataFatchingState extends ContractProviderState {}

class ContractAllDataFatchedState extends ContractProviderState {}

class DataLoadingState extends ContractProviderState {}

class DataLoadedState extends ContractProviderState {}

class PartyAddingState extends ContractProviderState {}

class PartyAddedState extends ContractProviderState {
  final String trxHash;
  PartyAddedState({required this.trxHash});
}

class PartyDeletingState extends ContractProviderState {}

class PartyDeletedState extends ContractProviderState {
  final String txHash;
  PartyDeletedState({required this.txHash});
}

class PartyFetchingState extends ContractProviderState {}

class PartyFetchedState extends ContractProviderState {
  final List<PartyModel> partiesList;
  PartyFetchedState({required this.partiesList});
}

class StateAddingState extends ContractProviderState {}

class StateAddedState extends ContractProviderState {
  final String trxHash;
  StateAddedState({required this.trxHash});
}

class StateDeletingState extends ContractProviderState {}

class StateDeletedState extends ContractProviderState {
  final String txHash;
  StateDeletedState({required this.txHash});
}

class StateFetchingState extends ContractProviderState {}

class StateFetchedState extends ContractProviderState {
  final List<StateModel> stateList;
  StateFetchedState({required this.stateList});
}

class FileUpoadingState extends ContractProviderState {}

class FileUpoadedState extends ContractProviderState {}

class ContractSuccessState extends ContractProviderState {}

class TimeSettingState extends ContractProviderState{}

class TimeSettedState extends ContractProviderState{
   final String message;
  TimeSettedState({required this.message});
}

class VotePausingState extends ContractProviderState{}

class VotePauseExcutedState extends ContractProviderState{
    final String txHash;
  VotePauseExcutedState({required this.txHash});
}

class ContractFailureState extends ContractProviderState {
  final String message;
  ContractFailureState({required this.message});
}
