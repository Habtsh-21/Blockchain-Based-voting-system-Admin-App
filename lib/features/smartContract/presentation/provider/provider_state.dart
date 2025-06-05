import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/state_model.dart';
import 'package:equatable/equatable.dart';

abstract class ContractProviderState extends Equatable {
  @override
  List<Object?> get props => [];
}

// === Base Success & Failure States ===

abstract class SuccessState<T> extends ContractProviderState {
  final T message;
  SuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}

abstract class FailureState<T> extends ContractProviderState {
  final T message;
  FailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

// === Initial State ===

class ContractInitialState extends ContractProviderState {}

// === All Data States ===

class ContractAllDataFetchingState extends ContractProviderState {}

class ContractAllDataFetchedState extends SuccessState<String> {
  ContractAllDataFetchedState({required super.message});
}

class ContractAllDataFailureState extends FailureState<String> {
  ContractAllDataFailureState({required super.message});
}

// === Party States ===

class PartyAddingState extends ContractProviderState {}

class PartyAddedState extends SuccessState<String> {
  PartyAddedState({required super.message});
}

class PartyAddFailureState extends FailureState<String> {
  PartyAddFailureState({required super.message});
}

class PartyDeletingState extends ContractProviderState {}

class PartyDeletedState extends SuccessState<String> {
  PartyDeletedState({required super.message});
}

class PartyDeleteFailureState extends FailureState<String> {
  PartyDeleteFailureState({required super.message});
}

class PartyFetchingState extends ContractProviderState {}

class PartyFetchedState extends ContractProviderState {
  final List<PartyModel> parties;
  PartyFetchedState({required this.parties});

  @override
  List<Object?> get props => [parties];
}

class PartyFetchFailureState extends FailureState<String> {
  PartyFetchFailureState({required super.message});
}

// === State (Region) States ===

class StateAddingState extends ContractProviderState {}

class StateAddedState extends SuccessState<String> {
  StateAddedState({required super.message});
}

class StateAddFailureState extends FailureState<String> {
  StateAddFailureState({required super.message});
}

class StateDeletingState extends ContractProviderState {}

class StateDeletedState extends SuccessState<String> {
  StateDeletedState({required super.message});
}

class StateDeleteFailureState extends FailureState<String> {
  StateDeleteFailureState({required super.message});
}

class StateFetchingState extends ContractProviderState {}

class StateFetchedState extends ContractProviderState {
  final List<StateModel> states;
  StateFetchedState({required this.states});

  @override
  List<Object?> get props => [states];
}

class StateFetchFailureState extends FailureState<String> {
  StateFetchFailureState({required super.message});
}

// === File Upload States ===

class FileUploadingState extends ContractProviderState {}

class FileUploadedState extends SuccessState<String> {
  FileUploadedState({required super.message});
}

class FileUploadFailureState extends FailureState<String> {
  FileUploadFailureState({required super.message});
}

// === Time Setting States ===

class TimeSettingState extends ContractProviderState {}

class TimeSettedState extends SuccessState<String> {
  TimeSettedState({required super.message});
}

class TimeSettingFailureState extends FailureState<String> {
  TimeSettingFailureState({required super.message});
}

// === Voting Control States ===

class VotePausingState extends ContractProviderState {}

class VotePausedState extends SuccessState<String> {
  VotePausedState({required super.message});
}

class VotePauseFailureState extends FailureState<String> {
  VotePauseFailureState({required super.message});
}

class VoteResumingState extends ContractProviderState {}

class VoteResumedState extends SuccessState<String> {
  VoteResumedState({required super.message});
}

class VoteResumeFailureState extends FailureState<String> {
  VoteResumeFailureState({required super.message});
}


class TransferingOwnershipState extends ContractProviderState {}

class OwnershipTransferedState extends SuccessState<String> {
  OwnershipTransferedState({required super.message});
}

class OwnershipTransferFailureState extends FailureState<String> {
  OwnershipTransferFailureState({required super.message});
}


// === Generic Fallback States (Optional) ===

class ContractSuccessState extends SuccessState<String> {
  ContractSuccessState({required super.message});
}

class ContractFailureState extends FailureState<String> {
  ContractFailureState({required super.message});
}
