//
// Copyright 2021 Free TON Wallet Team
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// 	http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import "dart:collection" show UnmodifiableListView;
import "dart:convert" show base64Encode;

import "package:flutter/widgets.dart" show ChangeNotifier;
import "package:freemework/freemework.dart" show CancellationToken;
import "package:freemework/freemework.dart"
    show FreemeworkException;
import "package:freemework_cancellation/freemework_cancellation.dart" show CancellationTokenSource, ManualCancellationTokenSource;
import "package:pedantic/pedantic.dart" show unawaited;

import "../data/account_info.dart" show AccountInfo;
import "../data/account_status.dart" show AccountType;
import "../misc/destroyable.dart" show Destroyable;
import "../misc/ton_decimal.dart" show TonDecimal;
import "../model/account_model.dart" show AccountModel;
import "../model/key_pair_model.dart" show KeyPairModel;
import "../services/blockchain/blockchain.dart" show BlockchainService, SmartContractAbi, SmartContractBlob, SmartContractKeeper;

import "account_view_mode.dart" show AccountViewModel;
import "seed_view_model.dart" show SeedViewModel;

class KeyPairViewModel extends ChangeNotifier implements Destroyable {
  final SeedViewModel parentSeed;

  final CancellationTokenSource _destroyCancellationTokenSource;
  final BlockchainService _blockchainService;
  final KeyPairModel _keyPairModel;
  final List<AccountViewModel> _accounts;

  KeyPairViewModel(
    this._blockchainService,
    this._keyPairModel,
    this.parentSeed,
  )   : this._accounts = <AccountViewModel>[],
        this._destroyCancellationTokenSource = ManualCancellationTokenSource() {
    //
    this._accounts.addAll(_keyPairModel.accounts
        .map(
            (AccountModel accountModel) => AccountViewModel(accountModel, this))
        .toList(growable: false));

    unawaited(this._safeBackgroundAccountLoader(
        this._destroyCancellationTokenSource.token));
  }

  @override
  void destroy() {
    this._destroyCancellationTokenSource.cancel();
  }

  int get keyPairId => this._keyPairModel.keyPairId;
  String get name => this._keyPairModel.name;
  String get keyPublic => this._keyPairModel.keyPublic;

  bool get isCollapsed => this._keyPairModel.isCollapsed;
  void set isCollapsed(bool value) {
    if (this._keyPairModel.isCollapsed != value) {
      this._keyPairModel.isCollapsed = value;
      this.parentSeed.appViewModel.scheduleSaveUiData();
      this.notifyListeners();
    }
  }

  bool get isHidden => this._keyPairModel.isHidden;
  void set isHidden(bool value) {
    if (this._keyPairModel.isHidden != value) {
      this._keyPairModel.isHidden = value;
      this.parentSeed.appViewModel.scheduleSaveUiData();
      this.notifyListeners();
    }
  }

  bool get hasMnemonicPhrase => true; // TODO

  UnmodifiableListView<AccountViewModel> get accounts =>
      UnmodifiableListView<AccountViewModel>(this._accounts);

  Future<void> _safeBackgroundAccountLoader(
      CancellationToken cancellationToken) async {
    while (!cancellationToken.isCancellationRequested) {
      try {
        for (final SmartContractBlob smartContractBlob
            in SmartContractKeeper.instance.all) {
          //
          final SmartContractAbi smartContractAbi = smartContractBlob.abi;
          final String tvcBase64 = base64Encode(smartContractBlob.tvc);

          final String accountAddress =
              await this._blockchainService.resolveAccountAddress(
                    this.keyPublic,
                    smartContractAbi.spec,
                    tvcBase64,
                  );

          final AccountInfo accountData = await this
              ._blockchainService
              .fetchAccountInformation(accountAddress);

          final AccountType accountType = accountData.isSmartContractDeployed
              ? AccountType.ACTIVE
              : AccountType.UNINITIALIZED;

          final TonDecimal balance = accountData.balance;

          AccountViewModel? accountViewModel =
              this.accounts.cast<AccountViewModel?>().singleWhere(
                    (AccountViewModel? account) =>
                        account!.blockchainAddress == accountAddress,
                    orElse: () => null,
                  );
          if (accountViewModel == null) {
            final AccountModel newAccountModel = AccountModel(
              address: accountAddress,
              contractQualifiedName: smartContractBlob.qualifiedName,
            );
            accountViewModel = AccountViewModel(newAccountModel, this);
            this._keyPairModel.accounts.add(newAccountModel);
            this._accounts.add(accountViewModel);
            this.notifyListeners();
          }

          accountViewModel.balance = balance;
          accountViewModel.accountType = accountType;
        }

        await this.parentSeed.appViewModel.persist();

        return;
      } catch (e) {
        final FreemeworkException err = FreemeworkException.wrapIfNeeded(e);
        print(err.message);
        await Future<void>.delayed(Duration(seconds: 5));
      }
    }
  }
}
