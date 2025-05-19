import 'dart:io';

import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/party_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/representative_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/state_entity.dart';

abstract class ContractRepository {
  ContractData addParty(PartyEntity partyEntity);
  ContractData addState(StateEntity stateEntity);
  ContractData addRep(RepresentativeEntity repEntity);
  ContractPartyList getParty();
  ContractStateList getState();
  ContractRepList getRep();
  ContractData deleteParty(int partyId);
  ContractData deleteState(int stateId);
  ContractData deleteRep(int partyId, int stateId);
  ContractData uploadImage(File pickedFile, String fileName);
}
