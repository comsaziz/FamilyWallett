// services/blockchain_manager.dart
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BlockchainManager {
  late Web3Client _client;
  late DeployedContract _contract;
  late EthPrivateKey _credentials;

  static final BlockchainManager _instance = BlockchainManager._internal();

  factory BlockchainManager() {
    return _instance;
  }

  BlockchainManager._internal();

  Future<void> init() async {
    await dotenv.load();
    final ethClient = dotenv.env['ETH_CLIENT']!;
    final privateKey = dotenv.env['PRIVATE_KEY']!;

    _client = Web3Client(ethClient, Client());
    _credentials = EthPrivateKey.fromHex(privateKey);
    await _loadContract();
  }

  Future<void> _loadContract() async {
    String abi = await rootBundle.loadString('assets/TransactionABI.json');
    String contractAddress = "YOUR_CONTRACT_ADDRESS";

    _contract = DeployedContract(
      ContractAbi.fromJson(abi, 'Transaction'),
      EthereumAddress.fromHex(contractAddress),
    );
  }

  Future<void> setMaxTransferAmount(BigInt amount) async {
    var function = _contract.function('setMaxTransferAmount');
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract, function: function, parameters: [amount]
      ),
      chainId: null,
    );
  }

  // Additional functions for other contract interactions
}
