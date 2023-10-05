import 'package:cowchain_farm/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

class CowContract {
  CowContract._();

  /// Stellar SDK
  static StellarSDK sdk = StellarSDK.TESTNET;

  /// Soroban Server
  static SorobanServer server = SorobanServer('https://soroban-testnet.stellar.org:443');

  /// Contract ADDRESS
  static ContractADDRESS contractADDRESS =
      "CALZXQICGW7E6N5TXBTP423OEG37M2KRUU5HG2EYIUU365A6VZA4HLXJ";

  /// Contract ID
  static ContractID getContractID() => StrKey.decodeContractIdHex(contractADDRESS);

  /// [getLatestLedgerSequence]
  /// Latest Soroban Ledger Sequence
  static Future<int> getLatestLedgerSequence() async {
    try {
      GetLatestLedgerResponse data = await server.getLatestLedger();
      return data.sequence ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// [invokeBuyCow]
  /// call buy_cow function on Cowchain Farm Soroban contract
  static Future<(BuyCowResult, String?)> invokeBuyCow({
    required String accountID,
    required String cowName,
    required String cowID,
    required CowBreed cowBreed,
  }) async {
    // Retrieve Cow Breed ID based on its Breed
    int cowBreedID = switch (cowBreed) {
      CowBreed.jersey => 1,
      CowBreed.limousin => 2,
      CowBreed.hallikar => 3,
      CowBreed.hereford => 4,
      CowBreed.holstein => 5,
      CowBreed.simmental => 6,
    };

    // Retrieve Account Information
    AccountResponse account = await sdk.accounts.account(accountID);

    // ! The arguments ORDER must be EXACTLY the SAME as the order of Soroban Function Arguments
    List<XdrSCVal> arguments = [
      XdrSCVal.forAccountAddress(accountID),
      XdrSCVal.forSymbol(cowName),
      XdrSCVal.forString(cowID),
      XdrSCVal.forU32(cowBreedID),
    ];

    // Build Operation
    InvokeContractHostFunction hostFunction = InvokeContractHostFunction(
      getContractID(),
      CowchainFunction.buyCow.name(),
      arguments: arguments,
    );
    InvokeHostFunctionOperation functionOperation = InvokeHostFuncOpBuilder(hostFunction).build();

    // Submit Transaction
    var (GetTransactionResponse? txResponse, FormatException? error) = await SorobanHelper.submitTx(
      server: server,
      operation: functionOperation,
      account: account,
      useAuth: true,
    );
    if (error != null) return (BuyCowResult.zero(), error.message);

    // Process Response
    txResponse = txResponse as GetTransactionResponse;
    if (server.enableLogging) {
      debugPrint('Transaction Response status: ${txResponse.status}');
    }

    if (txResponse.status == GetTransactionResponse.STATUS_SUCCESS) {
      XdrSCVal? resVal = txResponse.getResultValue();
      if (resVal == null || resVal.map == null) return (BuyCowResult.zero(), AppMessages.noResult);
      BuyCowResult buyCowResult = await CowHelper.parseResult(CowchainFunction.buyCow, resVal);
      return (buyCowResult, null);
    }

    return (BuyCowResult.zero(), AppMessages.processFails);
  }

  /// [invokeSellCow]
  /// call sell_cow function on Cowchain Farm Soroban contract
  static Future<(SellCowResult, String?)> invokeSellCow({
    required String accountID,
    required String cowID,
  }) async {
    // Retrieve Account Information
    AccountResponse account = await sdk.accounts.account(accountID);

    // ! The arguments ORDER must be EXACTLY the SAME as the order of Soroban Function Arguments
    List<XdrSCVal> arguments = [
      XdrSCVal.forAccountAddress(accountID),
      XdrSCVal.forString(cowID),
    ];

    // Build Operation
    InvokeContractHostFunction hostFunction = InvokeContractHostFunction(
      getContractID(),
      CowchainFunction.sellCow.name(),
      arguments: arguments,
    );
    InvokeHostFunctionOperation functionOperation = InvokeHostFuncOpBuilder(hostFunction).build();

    // Submit Transaction
    var (GetTransactionResponse? txResponse, FormatException? error) = await SorobanHelper.submitTx(
      server: server,
      operation: functionOperation,
      account: account,
      useAuth: true,
    );
    if (error != null) return (SellCowResult.zero(), error.message);

    // Process Response
    txResponse = txResponse as GetTransactionResponse;
    if (server.enableLogging) {
      debugPrint('Transaction Response status: ${txResponse.status}');
    }

    if (txResponse.status == GetTransactionResponse.STATUS_SUCCESS) {
      XdrSCVal? resVal = txResponse.getResultValue();
      if (resVal == null || resVal.map == null) return (SellCowResult.zero(), AppMessages.noResult);
      SellCowResult sellCowResult = await CowHelper.parseResult(CowchainFunction.sellCow, resVal);
      return (sellCowResult, null);
    }

    return (SellCowResult.zero(), AppMessages.processFails);
  }

  /// [invokeCowAppraisal]
  /// call cow_appraisal function on Cowchain Farm Soroban contract
  static Future<(CowAppraisalResult, String?)> invokeCowAppraisal({
    required String accountID,
    required String cowID,
  }) async {
    // Retrieve Account Information
    AccountResponse account = await sdk.accounts.account(accountID);

    // ! The arguments ORDER must be EXACTLY the SAME as the order of Soroban Function Arguments
    List<XdrSCVal> arguments = [
      XdrSCVal.forString(cowID),
    ];

    // Build Operation
    InvokeContractHostFunction hostFunction = InvokeContractHostFunction(
      getContractID(),
      CowchainFunction.cowAppraisal.name(),
      arguments: arguments,
    );
    InvokeHostFunctionOperation functionOperation = InvokeHostFuncOpBuilder(hostFunction).build();

    // Submit Transaction
    var (GetTransactionResponse? txResponse, FormatException? error) = await SorobanHelper.submitTx(
      server: server,
      operation: functionOperation,
      account: account,
      useAuth: false,
    );
    if (error != null) return (CowAppraisalResult.zero(), error.message);

    // Process Response
    txResponse = txResponse as GetTransactionResponse;
    if (server.enableLogging) {
      debugPrint('Transaction Response status: ${txResponse.status}');
    }

    if (txResponse.status == GetTransactionResponse.STATUS_SUCCESS) {
      XdrSCVal? resVal = txResponse.getResultValue();
      if (resVal == null || resVal.map == null) {
        return (CowAppraisalResult.zero(), AppMessages.noResult);
      }
      CowAppraisalResult cowAppraisalResult =
          await CowHelper.parseResult(CowchainFunction.cowAppraisal, resVal);
      return (cowAppraisalResult, null);
    }

    return (CowAppraisalResult.zero(), AppMessages.processFails);
  }

  /// [invokeFeedTheCow]
  /// call feed_the_cow function on Cowchain Farm Soroban contract
  static Future<(FeedTheCowResult, String?)> invokeFeedTheCow({
    required String accountID,
    required String cowID,
  }) async {
    // Retrieve Account Information
    AccountResponse account = await sdk.accounts.account(accountID);

    // ! The arguments ORDER must be EXACTLY the SAME as the order of Soroban Function Arguments
    List<XdrSCVal> arguments = [
      XdrSCVal.forAccountAddress(accountID),
      XdrSCVal.forString(cowID),
    ];

    // Build Operation
    InvokeContractHostFunction hostFunction = InvokeContractHostFunction(
      getContractID(),
      CowchainFunction.feedTheCow.name(),
      arguments: arguments,
    );
    InvokeHostFunctionOperation functionOperation = InvokeHostFuncOpBuilder(hostFunction).build();

    // Submit Transaction
    var (GetTransactionResponse? txResponse, FormatException? error) = await SorobanHelper.submitTx(
      server: server,
      operation: functionOperation,
      account: account,
      useAuth: false,
    );
    if (error != null) return (FeedTheCowResult.zero(), error.message);

    // Process Response
    txResponse = txResponse as GetTransactionResponse;
    if (server.enableLogging) {
      debugPrint('Transaction Response status: ${txResponse.status}');
    }

    if (txResponse.status == GetTransactionResponse.STATUS_SUCCESS) {
      XdrSCVal? resVal = txResponse.getResultValue();
      if (resVal == null || resVal.map == null) {
        return (FeedTheCowResult.zero(), AppMessages.noResult);
      }
      FeedTheCowResult feedTheCowResult =
          await CowHelper.parseResult(CowchainFunction.feedTheCow, resVal);
      return (feedTheCowResult, null);
    }

    return (FeedTheCowResult.zero(), AppMessages.processFails);
  }

  /// [invokeGetAllCow]
  /// call get_all_cow function on Cowchain Farm Soroban contract
  static Future<(GetAllCowResult, String?)> invokeGetAllCow({
    required String accountID,
  }) async {
    // Retrieve Account Information
    AccountResponse account = await sdk.accounts.account(accountID);

    // ! The arguments ORDER must be EXACTLY the SAME as the order of Soroban Function Arguments
    List<XdrSCVal> arguments = [
      XdrSCVal.forAccountAddress(accountID),
    ];

    // Build Operation
    InvokeContractHostFunction hostFunction = InvokeContractHostFunction(
      getContractID(),
      CowchainFunction.getAllCow.name(),
      arguments: arguments,
    );
    InvokeHostFunctionOperation functionOperation = InvokeHostFuncOpBuilder(hostFunction).build();

    // Build Transaction
    Transaction transaction = TransactionBuilder(account).addOperation(functionOperation).build();

    // ! Get data from Soroban contract using SimulateTransactionResponse / Preflight
    // ! This way we can retrieve user data without paying for the transaction fee.
    // Simulate Transaction
    SimulateTransactionResponse simulateResponse = await server.simulateTransaction(transaction);
    if (simulateResponse.resultError?.contains('Error') ?? false) {
      if (server.enableLogging) {
        debugPrint('simulateResponse Error: ${simulateResponse.jsonResponse['result']['error']}');
      }
      return (GetAllCowResult.zero(), AppMessages.tryAgain);
    }

    // Retrieve Simulate Transaction Result XDR
    List<SimulateTransactionResult> preflightResult = simulateResponse.results ?? [];
    if (preflightResult.isEmpty) return (GetAllCowResult.zero(), AppMessages.notFound);

    // Process Response
    XdrSCVal? resVal = preflightResult.first.resultValue;
    if (resVal == null || resVal.map == null) {
      return (GetAllCowResult.zero(), AppMessages.noResult);
    }
    GetAllCowResult getAllCowResult =
        await CowHelper.parseResult(CowchainFunction.getAllCow, resVal);
    return (getAllCowResult, null);
  }
}
