import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/party_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/state_entity.dart';
import 'package:equatable/equatable.dart';

class RepresentativeEntity extends Equatable {
  final String repName;
  final String repPhoto;
  final int partyId;
  final int stateId;
  final int votes;

  const RepresentativeEntity(
      {required this.repName,
      required this.repPhoto,
      required this.partyId,
      required this.stateId,
      this.votes = 0,
      });

  @override
  List<Object?> get props => [partyId, stateId];
}
