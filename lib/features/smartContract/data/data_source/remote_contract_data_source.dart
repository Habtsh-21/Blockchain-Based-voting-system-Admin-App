import 'dart:convert';
import 'dart:io';

import 'package:blockchain_based_national_election_admin_app/core/exception/exception.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/rep_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/state_model.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

const String _rpcUrl =
    'https://eth-sepolia.g.alchemy.com/v2/-ojPUotrULaRUfZmH3MRZTFQ7OH1wB22';
const String _wsUrl =
    'ws://eth-sepolia.g.alchemy.com/v2/-ojPUotrULaRUfZmH3MRZTFQ7OH1wB22';
const String contractAddress = "0xEF504cE4D8c5f16Cc9552B77b435B75cb517ccf8";
const String PRIVATE_KEY =
    "9d9a132e6a883f1effe0520f10ccf060c6829c2d9df2f30c7261dd704466fab4";

abstract class RemoteContractDataSource {
  Future<String> addParty(PartyModel partyModel);
  Future<String> addState(StateModel stateModel);
  Future<String> addRep(RepresentativeModel repModel);
  Future<String> deleteParty(int partyId);
  Future<String> deleteState(int stateId);
  Future<String> deleteRep(int partyId, int stateId);
  Future<List<PartyModel>> getParties();
  Future<List<StateModel>> getState();
  Future<List<RepresentativeModel>> getRep();
  Future<String> uploadImage(File pickedFile, String fileName);
}

class RemoteContractDataSourceImpl extends RemoteContractDataSource {
  late Web3Client _client;
  late DeployedContract _contract;
  late ContractFunction _addParty;
  late ContractFunction _addState;
  late ContractFunction _addRep;
  late ContractFunction _deleteParty;
  late ContractFunction _deleteState;
  late ContractFunction _deleteRep;
  late ContractFunction _getParties;
  late ContractFunction _getStates;
  late ContractFunction _getReps;
  late EthereumAddress _contractAddress;
  late ContractAbi _contractAbi;
  late Credentials _credentials;

  Future<void> init() async {
    _client = Web3Client(
      _rpcUrl,
      Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );

    _credentials = EthPrivateKey.fromHex(PRIVATE_KEY);
    String abiString = await rootBundle.loadString('assets/file/json/abi.json');
    Map<String, dynamic> jsondecoded = jsonDecode(abiString);

    final abiJson = jsondecoded['abi'] as List<dynamic>;

    _contractAbi = ContractAbi.fromJson(jsonEncode(abiJson), 'Voting');

    _contractAddress = EthereumAddress.fromHex(contractAddress);

    _contract = DeployedContract(
      _contractAbi,
      _contractAddress,
    );
  }

  @override
  Future<String> addParty(PartyModel partyModel) async {
    try {
      print(1);
      await init();
      print(2);
      print(
          "${partyModel.partyId} ${partyModel.partySymbol}  ${partyModel.partyName}");
      _addParty = _contract.function('addParty');
      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
            contract: _contract,
            function: _addParty,
            parameters: [
              partyModel.partyName,
              partyModel.partySymbol,
              BigInt.from(partyModel.partyId)
            ],
          ),
          chainId: 11155111);
      print(3);
      print('transaction hash --- $transactionHash');
      return transactionHash;
    } catch (e) {
      print(e.toString());
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<String> addState(StateModel stateModel) async {
    try {
      print(1);
      await init();
      print(2);
      _addState = _contract.function('addState');
      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _addState,
              parameters: stateModel.toList()),
          chainId: 11155111);
      print(3);
      print('trx:$transactionHash');
      return transactionHash;
    } catch (e) {
      print(e.toString());
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<String> addRep(RepresentativeModel repModel) async {
    try {
      print('1a');
      await init();
      print('2a');
      _addRep = _contract.function('assignRepresentative');
      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _addRep,
              parameters: repModel.toList()),
          chainId: 11155111);
      print('txHash:   $transactionHash');
      return transactionHash;
    } catch (e) {
      print(e.toString());
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<String> deleteParty(int partyId) async {
    try {
      print('11d');
      await init();
      print('12d');
      _deleteParty = _contract.function('delateParty');
      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _deleteParty,
              parameters: [BigInt.from(partyId)]),
          chainId: 11155111);

      print('delete: $transactionHash');
      return transactionHash;
    } catch (e) {
      print('error : ${e.toString()}');
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<String> deleteRep(int partyId, int stateId) async {
    try {
      await init();
      _deleteRep = _contract.function('delateRep');
      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _deleteRep,
              parameters: [stateId, partyId]),
          chainId: 11155111);
      return transactionHash;
    } catch (e) {
      print(e.toString());
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<String> deleteState(int stateId) async {
    try {
      await init();
      _deleteState = _contract.function('delateState');
      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _deleteState,
              parameters: [stateId]),
          chainId: 11155111);
      return transactionHash;
    } catch (e) {
      print(e.toString());
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<List<PartyModel>> getParties() async {
    try {
      print(1);
      await init();
      print(2);
      _getParties = _contract.function('partiesList');
      final result = await _client.call(
        contract: _contract,
        function: _getParties,
        params: [],
      );
      // print('result: $result:  ${result.length}');
      // print('result: ${result.length}');
      final rawList = result[0] as List;
      // print('raw:  $rawList');
      final completeParties = rawList.where((item) {
        return item is List && item.length == 4;
      }).toList();
      // print('complate :   $completeParties: ${completeParties.length}');
      // print('complate :  ${completeParties.length}');

      List<PartyModel> partyList = [];
      for (List<dynamic> party in completeParties) {
        final partyId = int.tryParse(party[2].toString());
        final votes = int.tryParse(party[3].toString());

        if (party[0] !=
                null && //in our smart contract when party object delete, partyname and symbol  become empty not completely removed. what is way we have to check whether they are empty or not
            party[0].toString().isNotEmpty &&
            party[0] != null &&
            party[0].toString().isNotEmpty &&
            partyId != null &&
            votes != null) {
          partyList.add(PartyModel(
            partyName: party[0] as String,
            partySymbol: party[1] as String,
            partyId: partyId,
            votes: votes,
          ));
        } else {
          print("Skipping invalid entry: $party");
        }
      }
      return partyList;
    } catch (e) {
      print('party error:   ${e.toString()}');
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<List<RepresentativeModel>> getRep() async {
    try {
      await init();
      _getReps = _contract.function('repList');
      final result = await _client.call(
        contract: _contract,
        function: _getReps,
        params: [],
      );
      final rawList = result[0] as List;
      print(rawList);
      final completeReps = rawList.where((item) {
        return item is List && item.length == 5;
      }).toList();

      final repList = completeReps.map((rep) {
        return RepresentativeModel(
          repName: rep[0] as String,
          repPhoto: rep[1] as String,
          partyId: int.parse(rep[2].toString()),
          stateId: int.parse(rep[3].toString()),
          votes: int.parse(rep[4].toString()),
        );
      }).toList();
      print('Representative: $repList');
      return repList;
    } catch (e) {
      print('representative error:   ${e.toString()}');
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<List<StateModel>> getState() async {
    try {
      await init();

      _getStates = _contract.function('statesList');
      final result = await _client.call(
        contract: _contract,
        function: _getStates,
        params: [],
      );
      final rawList = result[0] as List;

      final completeStates = rawList.where((item) {
        return item is List && item.length == 2;
      }).toList();

      final stateList = completeStates.map((state) {
        return StateModel(
          stateName: state[0] as String,
          stateId: int.parse(state[1].toString()),
        );
      }).toList();

      return stateList;
    } catch (e) {
      print('state error:   ${e.toString()}');
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<String> uploadImage(pickedFile, String fileName) async {
    try {
      final storage = Supabase.instance.client.storage;
      final bucket = storage.from('main');

      await bucket.upload(
        fileName,
        pickedFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      final publicUrl = bucket.getPublicUrl(fileName);

      if (publicUrl.isEmpty) {
        throw NullPublicUrlException();
      }
      final response = await http.head(Uri.parse(publicUrl));
      if (response.statusCode != 200) {
        throw Exception('Uploaded file not accessible at $publicUrl');
      }

      print("Upload successful. URL: $publicUrl");
      return publicUrl;
    } on StorageException catch (e) {
      print("Supabase StorageException: ${e.message}");
      throw StorageException("Upload failed: ${e.message}");
    } on ClientException catch (e) {
      print("Supabase ClientException: ${e.message}");
      throw ClientException("Upload failed: ${e.message}");
    } on SocketException catch (e) {
      print("Supabase SocketException: ${e.message}");
      throw SocketException("Network issue: ${e.message}");
    } on NullPublicUrlException catch (e) {
      print(e);
      rethrow;
    } catch (e) {
      print("Unknown error during upload: $e");
      throw UnknownException();
    }
  }
}
