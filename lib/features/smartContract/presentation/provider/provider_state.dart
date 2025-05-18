import 'package:equatable/equatable.dart';

abstract class ContractProviderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContractInitialState extends ContractProviderState {}

class PartyAddingState extends ContractProviderState {}

class PartyAddedState extends ContractProviderState {}

class PartyDeletingState extends ContractProviderState {}

class PartyDeletedState extends ContractProviderState {}

class PartyFetchingState extends ContractProviderState {}

class PartyFetchedState extends ContractProviderState {
  // final List<PartyModel> partyList;
  // PartyFetchedState({required this.partyList});
}

class StateAddingState extends ContractProviderState {}

class StateAddedState extends ContractProviderState {}

class StateDeletingState extends ContractProviderState {}

class StateDeletedState extends ContractProviderState {}

class StateFetchingState extends ContractProviderState {}

class StateFetchedState extends ContractProviderState {
  // final List<StateModel> stateList;
  // StateFetchedState({required this.stateList});
}

class RepAddingState extends ContractProviderState {}

class RepAddedState extends ContractProviderState {}

class RepDeletingState extends ContractProviderState {}

class RepDeletedState extends ContractProviderState {}

class RepFetchingState extends ContractProviderState {}

class RepFetchedState extends ContractProviderState {
  // final List<RepresentativeModel> repList;

  // RepFetchedState({required this.repList});
}

class ContractSuccessState extends ContractProviderState {}

class ContractFailureState extends ContractProviderState {
  final String message;
  ContractFailureState({required this.message});
}
