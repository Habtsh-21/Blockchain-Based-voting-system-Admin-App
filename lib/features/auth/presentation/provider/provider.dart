import 'package:blockchain_based_national_election_admin_app/core/failure/failure.dart';
import 'package:blockchain_based_national_election_admin_app/core/network/network.dart';
import 'package:blockchain_based_national_election_admin_app/core/string/string.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/data/data_source/remote_data_source.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/domain/entities/admin_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/domain/repository/auth_repo.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/domain/usecase/loginusecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/domain/usecase/logoutusecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/domain/usecase/usersdata_usecase.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/presentation/provider/provider_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final connectionProvider = Provider<InternetConnection>(
  (ref) => InternetConnection(),
);
final remoteSourceRepoProvider = Provider<RemoteDataSource>(
  (ref) => RemoteDataSourceImpl(),
);
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final connectionChecker = ref.watch(connectionProvider);
  return NetworkInfoImpl(connectionChecker);
});

final authRepoProvider = Provider<AuthRepository>(
  (ref) {
    final remoteDataSource = ref.watch(remoteSourceRepoProvider);
    final networkInfo = ref.watch(networkInfoProvider);
    return AuthRepoImplementation(
        remoteDataSource: remoteDataSource, networkInfo: networkInfo);
  },
);

final logInUsecaseProvider = Provider<LogInUsecase>(
  (ref) {
    final authRepository = ref.watch(authRepoProvider);
    return LogInUsecase(authRepository);
  },
);

final logOutUsercaseProvider = Provider<LogOutUsecase>(
  (ref) {
    final authRepository = ref.watch(authRepoProvider);
    return LogOutUsecase(authRepository);
  },
);

final usersDataProvider = Provider<UsersdataUsecase>(
  (ref) {
    final authRepository = ref.watch(authRepoProvider);
    return UsersdataUsecase(authRepository: authRepository);
  },
);

class AuthNotifier extends StateNotifier<AuthProviderState> {
  final LogInUsecase logInUsecase;
  final LogOutUsecase logOutUsecase;
  final UsersdataUsecase usersDataUsecase;
  AuthNotifier(
      {required this.logInUsecase,
      required this.logOutUsecase,
      required this.usersDataUsecase})
      : super(InitialState());

  int totalUsers = 0;
  Future<void> login(String email, String password) async {
    state = LoggingInState();

    final result =
        await logInUsecase(AdminEntity(email: email, password: password));

    state = result.fold(
        (failure) => LogInFailureState(message: _mapFailureToMessage(failure)),
        (r) => LoggedInState());
  }

  Future<void> logout() async {
    state = LogingOutState();
    final result = await logOutUsecase();
    state = result.fold(
        (failure) => LogoutFailureState(message: _mapFailureToMessage(failure)),
        (r) => LoggedOutState());
  }

  Future<void> userData() async {
    state = UsersdataLoadingState();
    final result = await usersDataUsecase();
    state = result.fold(
        (failure) =>
            UsersdataFailureState(message: _mapFailureToMessage(failure)), (r) {
      totalUsers = r;
      return UsersdataLoadedState();
    });
  }
}

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthProviderState>((ref) {
  return AuthNotifier(
      logInUsecase: ref.watch(logInUsecaseProvider),
      logOutUsecase: ref.watch(logOutUsercaseProvider),
      usersDataUsecase: ref.watch(usersDataProvider));
});

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case const (InvalidEmailFailure):
      return INVALID_EMAIL;
    case const (UserDisabledFailure):
      return USER_DISABLED;
    case const (EmailAlreadyInUseFailure):
      return ALREADY_LOGGED_IN;
    case const (OperationNotAllowedFailure):
      return OPERATION_IS_NOT_ALLOWED;
    case const (ServerFailure):
      return SERVER_FAILURE_MESSAGE;
    case const (OfflineFailure):
      return OFFLINE_FAILURE_MESSAGE;
    case const (UserNotFoundFailure):
      return NO_USER_FAILURE_MESSAGE;
    case const (TooManyRequestsFailure):
      return TOO_MANY_REQUESTS_FAILURE_MESSAGE;
    case const (TransactionFailedFailure):
      return (failure as TransactionFailedFailure).message;
    case const (WrongPasswordFailure):
      return WRONG_PASSWORD_FAILURE_MESSAGE;
    default:
      return "Unexpected Error , Please try again later .";
  }
}
