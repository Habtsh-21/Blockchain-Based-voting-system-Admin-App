import 'package:blockchain_based_national_election_admin_app/core/exception/exception.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/data/model/admin_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class RemoteDataSource {
  Future<void> logIn(AdminModel adminModel);
  Future<void> logOut();
  Future<int> usersData();
}

class RemoteDataSourceImpl extends RemoteDataSource {
  final supabase = Supabase.instance.client;
  @override
  Future<void> logIn(AdminModel adminModel) async {
    print('Trying login with: ${adminModel.email}/${adminModel.password}');

    try {
      final response = await supabase.auth.signInWithPassword(
          email: adminModel.email, password: adminModel.password);
      if (response.user == null) {
        throw ServerException();
      }
      if (response.user != null) {
        print("logged in man");
      }
    } on AuthException catch (e) {
      print('auth exception: code=${e.code}, message=${e.message}');
      final message = e.message.toLowerCase();
      if (message.contains('invalid login credentials')) {
        throw WrongPasswordException();
      } else if (message.contains('invalid email')) {
        throw InvalidEmailException();
      } else if (message.contains('user not found')) {
        throw UserNotFoundException();
      } else if (message.contains('signups not allowed')) {
        throw OperationNotAllowedException();
      } else if (message.contains('too many requests')) {
        throw TooManyRequestsException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      print('Other error: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      print('Logout successful');
    } catch (e) {
      print('Logout failed: $e');
      throw ServerException();
    }
  }

  Future<int> usersData() async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .count(CountOption.exact);
      print('total COUNT: $response');
      return response;
    } catch (e) {
      throw TransactionFailedException(message: e.toString());
    }
  }
}
