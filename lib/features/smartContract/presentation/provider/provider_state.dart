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

class PartyFetchedState extends ContractProviderState {}

class StateAddingState extends ContractProviderState {}

class StateAddedState extends ContractProviderState {}

class StateDeletingState extends ContractProviderState {}

class StateDeletedState extends ContractProviderState {}

class StateFetchingState extends ContractProviderState {}

class StateFetchedState extends ContractProviderState {}

class RepAddingState extends ContractProviderState {}

class RepAddedState extends ContractProviderState {}

class RepDeletingState extends ContractProviderState {}

class RepDeletedState extends ContractProviderState {}

class RepFetchingState extends ContractProviderState {}

class RepFetchedState extends ContractProviderState {}

class ContractSuccessState extends ContractProviderState {}

class ContractFailureState extends ContractProviderState {
  final String message;
 ContractFailureState({required this.message});
}
