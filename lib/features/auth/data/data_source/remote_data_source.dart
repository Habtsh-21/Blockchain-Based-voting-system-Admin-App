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
      final adminCheck = await supabase
          .from('admins')
          .select()
          .eq('email', adminModel.email)
          .maybeSingle();

      print('Admin check result: $adminCheck');

      if (adminCheck == null) {
        throw TransactionFailedException(message: 'Only admins can login');
      }

      final response = await supabase.auth.signInWithPassword(
        email: adminModel.email,
        password: adminModel.password,
      );

      if (response.user == null) {
        throw TransactionFailedException(message: 'Login failed, try again');
      }
    } on AuthException catch (e) {
      final message = e.message.toLowerCase();
      if (message.contains('invalid login credentials') ||
          message.contains('user not found')) {
        throw TransactionFailedException(
            message: 'Incorrect email or password');
      } else if (message.contains('too many requests')) {
        throw TransactionFailedException(
            message: 'Too many attempts, try later');
      } else {
        throw TransactionFailedException(message: 'Login error: ${e.message}');
      }
    } on TransactionFailedException {
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
      throw TransactionFailedException(message: 'Unexpected error occurred');
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




// -- Create the admin user
// INSERT INTO auth.users (
//   id,
//   email,
//   encrypted_password,
//   raw_user_meta_data,
//   created_at,
//   updated_at,
//   email_confirmed_at
// ) VALUES (
//   gen_random_uuid(), -- Generates a new UUID
//   'admin@example.com', -- Change to desired email
//   crypt('sec123', gen_salt('bf')), -- Password will be bcrypt hashed
//   '{"role":"admin","is_admin":true}', -- Sets admin metadata
//   now(),
//   now(),
//   now() -- Auto-confirms email
// );
