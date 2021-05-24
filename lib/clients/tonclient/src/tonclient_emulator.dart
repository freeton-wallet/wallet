import "package:freemework/freemework.dart" show ExecutionContext;
import 'package:freeton_wallet/clients/tonclient/src/models/keypair.dart';

import 'models/account_info.dart';
import '../contract.dart' show AbstractTonClient, SeedType;

class TonClient extends AbstractTonClient {
  @override
  Future<void> init(ExecutionContext executionContext) async {
    print("Initialize TonClient Emulator");
  }

  @override
  Future<String> generateMnemonicPhraseSeed(SeedType seedType) async {
    return "stub stub stub stub stub stub stub stub stub stub stub stub";
  }

  @override
  Future<KeyPair> deriveKeys(
      String mnemonicPhraseSeed, SeedType seedType) async {
    return KeyPair(
        public:
            "public public public public public public public public public",
        secret:
            "secret secret secret secret secret secret secret secret secret");
  }

  @override
  Future<String> getDeployData(
    String publicKey,
    String smartContractABI,
    String smartContractTVCBase64,
  ) async {
    // DeployData deployData = DeployData(
    //   accountId: "accountId",
    //   address: "address",
    //   dataBase64: "dataBase64",
    //   imageBase64: "imageBase64",
    // );
    return "address";
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
  Future<AccountInfo> getAccountInformation(String accountAddress) {
    // TODO: implement getAccountData
    throw UnimplementedError();
  }
}
