import 'package:equatable/equatable.dart';

abstract class ProviderState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class InitialState extends ProviderState {}

class LoggingInState extends ProviderState {}

class LoggedInState extends ProviderState {}

class LoggingOutState extends ProviderState {}

class LoggedOutState extends ProviderState {}

class FailureState extends ProviderState {
  final String message;
  FailureState({required this.message});
}
