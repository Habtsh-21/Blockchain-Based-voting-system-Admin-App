import 'dart:convert';
import 'dart:io';

import 'package:blockchain_based_national_election_admin_app/core/exception/exception.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/all_data_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/party_model.dart';
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
const String contractAddress = "0x5bF77EcF1559b7b0A3b0E5B8Fbb900D336526010";
//  "0x4F51C80508207Dc57b1Df9b51A96f4C7a8756B8c";
//  "0xf41e2dD55e52074E08d86541b564B01f2D008641";
// "0x248BE004170491254Fa7E3D4bd87979EF5f80855"; //updated contract address
//  "0x47aAa3f944C584CFc52FC2b4057Ac54206B5eE2D";
const String PRIVATE_KEY =
    "40bcc8600e04b79f7420f86bf89efe14c733f5356d661b304faaf1935a954be5";

abstract class RemoteContractDataSource {
  Future<String> addParty(PartyModel partyModel);
  Future<String> addState(StateModel stateModel);
  Future<String> deleteParty(int partyId);
  Future<String> deleteState(int stateId);
  Future<List<PartyModel>> getParties();
  Future<List<StateModel>> getState();
  Future<String> uploadImage(File pickedFile, String fileName);
  Future<AllDataModel> getAllData();
  Future<String> setTime(int startTime, int endTime);
  Future<String> transferOwnership(String newAddress);
  Future<String> pause(bool pause);
}

class RemoteContractDataSourceImpl extends RemoteContractDataSource {
  late Web3Client _client;
  late DeployedContract _contract;
  late ContractFunction _addParty;
  late ContractFunction _addState;
  late ContractFunction _deleteParty;
  late ContractFunction _deleteState;
  late ContractFunction _getParties;
  late ContractFunction _getStates;
  late ContractFunction _getAllData;
  late ContractFunction _setTime;
  late ContractFunction _transferOwnership;
  late ContractFunction _pause;
  late ContractFunction _resume;
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
      print(transactionHash);
      return transactionHash;
    } catch (e) {
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
      print(transactionHash);
      return transactionHash;
    } catch (e) {
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<String> deleteParty(int partyId) async {
    try {
      await init();
      _deleteParty = _contract.function('deleteParty');
      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _deleteParty,
              parameters: [BigInt.from(partyId)]),
          chainId: 11155111);

      return transactionHash;
    } catch (e) {
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<String> deleteState(int stateId) async {
    try {
      await init();
      _deleteState = _contract.function('deleteState');
      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _deleteState,
              parameters: [BigInt.from(stateId)]),
          chainId: 11155111);
      return transactionHash;
    } catch (e) {
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<List<PartyModel>> getParties() async {
    try {
      await init();
      _getParties = _contract.function('getAllParties');
      final result = await _client.call(
        contract: _contract,
        function: _getParties,
        params: [],
      );

      final rawList = result[0] as List;
      Map<int, int> stateVotes = {};
      final partyList = rawList.map((party) {
        List<List<int>> stateVoteList = (party[4] as List)
            .map(
              (e) => [
                int.parse(e[0].toString()),
                int.parse(e[1].toString()),
              ],
            )
            .toList();
        for (List<int> state in stateVoteList) {
          stateVotes[state[0]] = state[1];
        }
        return PartyModel(
          partyName: party[0] as String,
          partySymbol: party[1] as String,
          partyId: int.parse(party[2].toString()),
          votes: int.parse(party[3].toString()),
          stateVotes: stateVotes,
        );
      }).toList();
      return partyList;
    } catch (e) {
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

      final stateList = rawList.map((state) {
        return StateModel(
          stateName: state[0] as String,
          stateId: int.parse(state[1].toString()),
        );
      }).toList();

      return stateList;
    } catch (e) {
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<AllDataModel> getAllData() async {
    try {
      await init();

      _getAllData = _contract.function('getAllData');
      final result = await _client.call(
        contract: _contract,
        function: _getAllData,
        params: ['0x000000000000000000000'],
      );
      int totalVotes = 0;
      print(result);
      // Decode each item from result
      final rawStates = result[0] as List;
      final rawParties = result[1] as List;
      final votingPaused = result[2] as bool;
      final votingActive = result[3] as bool;
      final hasUserVoted = result[4] as bool;
      final start = int.parse(result[5].toString());
      final end = int.parse(result[6].toString());
      DateTime? startTime;
      DateTime? endTime;

      if (start != 0 && end != 0) {
        startTime = DateTime.fromMillisecondsSinceEpoch(start * 1000);
        endTime = DateTime.fromMillisecondsSinceEpoch(end * 1000);
      }

      final stateList = rawStates.map((state) {
        return StateModel(
          stateName: state[0] as String,
          stateId: int.parse(state[1].toString()),
        );
      }).toList();

      final partyList = rawParties.map((party) {
        int totalPartyVote = 0;
        Map<int, int> stateVotes = {};
        List<List<int>> stateVoteList = (party[3] as List)
            .map((e) => [
                  int.parse(e[0].toString()),
                  int.parse(e[1].toString()),
                ])
            .toList();

        for (List<int> state in stateVoteList) {
          stateVotes[state[0]] = state[1];
          totalPartyVote += state[1];
          totalVotes += state[1];
        }

        return PartyModel(
          partyName: party[0] as String,
          partySymbol: party[1] as String,
          partyId: int.parse(party[2].toString()),
          votes: totalPartyVote,
          stateVotes: stateVotes,
        );
      }).toList();

      return AllDataModel(
        parties: partyList,
        states: stateList,
        totalVotes: totalVotes,
        votingPaused: votingPaused,
        isVotringActive: votingActive,
        hasUserVoted: hasUserVoted,
        votingStateTime: startTime,
        votingEndTime: endTime,
      );
    } catch (e) {
      print(e.toString());
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<String> setTime(int startTime, int endTime) async {
    try {
      await init();
      _setTime = _contract.function('setVotingTimes');
      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
            contract: _contract,
            function: _setTime,
            parameters: [BigInt.from(startTime), BigInt.from(endTime)],
          ),
          chainId: 11155111);
      print('transaction hash --- $transactionHash');
      return transactionHash;
    } catch (e) {
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<String> transferOwnership(String newAddress) async {
    try {
      await init();
      _transferOwnership = _contract.function('transferOwnership');
      final newOwner = EthereumAddress.fromHex(newAddress);

      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
            contract: _contract,
            function: _transferOwnership,
            parameters: [newOwner],
          ),
          chainId: 11155111);
      print('transaction hash --- $transactionHash');
      return transactionHash;
    } catch (e) {
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

      return publicUrl;
    } on StorageException catch (e) {
      throw StorageException("Upload failed: ${e.message}");
    } on ClientException catch (e) {
      throw ClientException("Upload failed: ${e.message}");
    } on SocketException catch (e) {
      throw SocketException("Network issue: ${e.message}");
    } on NullPublicUrlException {
      rethrow;
    } catch (e) {
      throw UnknownException();
    }
  }

  @override
  Future<String> pause(bool pause) async {
    try {
      await init();
      String transactionHash;
      if (pause) {
        _pause = _contract.function('pauseVoting');
        transactionHash = await _client.sendTransaction(
            _credentials,
            Transaction.callContract(
              contract: _contract,
              function: _pause,
              parameters: [],
            ),
            chainId: 11155111);
      } else {
        _resume = _contract.function('resumeVoting');
        transactionHash = await _client.sendTransaction(
            _credentials,
            Transaction.callContract(
              contract: _contract,
              function: _resume,
              parameters: [],
            ),
            chainId: 11155111);
      }
      print('transaction hash --- $transactionHash');
      return transactionHash;
    } catch (e) {
      throw TransactionFailedException(message: e.toString());
    }
  }
}
