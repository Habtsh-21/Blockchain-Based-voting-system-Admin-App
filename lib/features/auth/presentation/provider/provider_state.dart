import 'package:equatable/equatable.dart';

abstract class AuthProviderState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

abstract class SuccessState extends AuthProviderState {}

abstract class FailureState extends AuthProviderState {
  final String message;
  FailureState({required this.message});
}

class InitialState extends AuthProviderState {}

class LoggingInState extends AuthProviderState {}

class LoggedInState extends SuccessState {}

class LogInFailureState extends FailureState {
  LogInFailureState({required super.message});
}

class LogingOutState extends AuthProviderState {}

class LoggedOutState extends SuccessState {}

class LogoutFailureState extends FailureState {
  LogoutFailureState({required super.message});
}

class UsersdataLoadingState extends AuthProviderState {}

class UsersdataLoadedState extends SuccessState {}

class UsersdataFailureState extends FailureState {
  UsersdataFailureState({required super.message});
}
