import "package:freemework/freemework.dart" show ExecutionContext;
import 'package:freeton_wallet/clients/tonclient/src/models/keyPair.dart';

import 'models/deployData.dart';
import "tonclient_contract.dart" show AbstractTonClient;

class TonClient extends AbstractTonClient {
  @override
  Future<void> init(ExecutionContext executionContext) async {
    print("Initialize TonClient Emulator");
  }

  @override
  Future<String> generateMnemonicPhrase() async {
    return "stub stub stub stub stub stub stub stub stub stub stub stub";
  }

  @override
  Future<KeyPair> deriveKeys(String seed) async {
    return KeyPair(
        public:
            "public public public public public public public public public",
        secret:
            "secret secret secret secret secret secret secret secret secret");
  }

  @override
  Future<TonDeployData> getDeployData(KeyPair keys) async {
    TonDeployData deployData = TonDeployData(
      accountId: "accountId",
      address: "address",
      dataBase64: "dataBase64",
      imageBase64: " imageBase64",
    );
    return deployData;
  }

  @override
  Future<dynamic> calcDeployFees(KeyPair keys) {
    // TODO: implement calcDeployFees
    throw UnimplementedError();
  }

  @override
  Future<dynamic> deployContract(KeyPair keys) {
    // TODO: implement deployContract
    throw UnimplementedError();
  }

  @override
  Future<dynamic> getAccountData(String address) {
    // TODO: implement getAccountData
    throw UnimplementedError();
  }
}
