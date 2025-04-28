import 'package:equatable/equatable.dart';

class AdminEntity extends Equatable {
  final String email;
  final String password;
  const AdminEntity({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
