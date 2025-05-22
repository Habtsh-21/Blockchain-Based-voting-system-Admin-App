import 'package:equatable/equatable.dart';

class RepresentativeEntity extends Equatable {
  final String repName;
  final String repPhoto;
  final int partyId;
  final int stateId;
  final int votes;

  const RepresentativeEntity({
    required this.repName,
    required this.repPhoto,
    required this.partyId,
    required this.stateId,
    this.votes = 0,
  });

  @override
  List<Object?> get props => [partyId, stateId];
}
