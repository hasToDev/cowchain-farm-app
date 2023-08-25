import 'package:cowchain_farm/main.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

class CowContract {
  CowContract._();

  /// Stellar SDK
  static StellarSDK sdk = StellarSDK.FUTURENET;

  /// Soroban Server
  static SorobanServer server = SorobanServer('https://rpc-futurenet.stellar.org:443')
    ..acknowledgeExperimental = true;

  /// Contract ADDRESS
  static ContractADDRESS contractADDRESS =
      "CB3UCV24SYTUFRZBEIMKVW5XKSJCGTMBCSJFN5OJ2SSXBTPRXO42KKE5";

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
    String functionName = "buy_cow";

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
      functionName,
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

      Status status = Status.fail;
      CowData? cowData;
      List<String> ownershipData = [];

      for (XdrSCMapEntry v in resVal.map!) {
        if (v.key.sym == null) continue;
        if (v.key.sym == 'status' && v.val.vec != null) {
          status = (v.val.vec?.first.sym ?? '').getStatus();
        }
        if (v.key.sym == 'cow_data' && v.val.map != null) {
          cowData = await getCowData(v.val.map!);
        }
        if (v.key.sym == 'ownership' && v.val.vec != null) {
          for (XdrSCVal data in v.val.vec!) {
            ownershipData.add(data.str.toString());
          }
        }
      }
      cowData ??= CowData.zero();

      return (BuyCowResult(status: status, data: cowData, ownership: ownershipData), null);
    }

    return (BuyCowResult.zero(), AppMessages.processFails);
  }

  /// [invokeSellCow]
  /// call sell_cow function on Cowchain Farm Soroban contract
  static Future<(SellCowResult, String?)> invokeSellCow({
    required String accountID,
    required String cowID,
  }) async {
    String functionName = "sell_cow";

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
      functionName,
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

      Status status = Status.fail;
      List<String> ownershipData = [];

      for (XdrSCMapEntry v in resVal.map!) {
        if (v.key.sym == null) continue;
        if (v.key.sym == 'status' && v.val.vec != null) {
          status = (v.val.vec?.first.sym ?? '').getStatus();
        }
        if (v.key.sym == 'ownership' && v.val.vec != null) {
          for (XdrSCVal data in v.val.vec!) {
            ownershipData.add(data.str.toString());
          }
        }
      }

      return (SellCowResult(status: status, ownership: ownershipData), null);
    }

    return (SellCowResult.zero(), AppMessages.processFails);
  }

  /// [invokeCowAppraisal]
  /// call cow_appraisal function on Cowchain Farm Soroban contract
  static Future<(CowAppraisalResult, String?)> invokeCowAppraisal({
    required String accountID,
    required String cowID,
  }) async {
    String functionName = "cow_appraisal";

    // Retrieve Account Information
    AccountResponse account = await sdk.accounts.account(accountID);

    // ! The arguments ORDER must be EXACTLY the SAME as the order of Soroban Function Arguments
    List<XdrSCVal> arguments = [
      XdrSCVal.forString(cowID),
    ];

    // Build Operation
    InvokeContractHostFunction hostFunction = InvokeContractHostFunction(
      getContractID(),
      functionName,
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

      Status status = Status.fail;
      String price = '';

      for (XdrSCMapEntry v in resVal.map!) {
        if (v.key.sym == null) continue;
        if (v.key.sym == 'status' && v.val.vec != null) {
          status = (v.val.vec?.first.sym ?? '').getStatus();
        }
        if (v.key.sym == 'price' && v.val.i128 != null) {
          int high = v.val.i128?.hi.int64 ?? 0;
          int low = v.val.i128?.lo.uint64 ?? 0;
          Int64 price64 = (Int64(1000000000) * Int64(high)) + Int64(low);
          price = (price64 ~/ Int64(10000000)).toString();
        }
      }

      return (CowAppraisalResult(status: status, price: price), null);
    }

    return (CowAppraisalResult.zero(), AppMessages.processFails);
  }

  /// [invokeFeedTheCow]
  /// call feed_the_cow function on Cowchain Farm Soroban contract
  static Future<(FeedTheCowResult, String?)> invokeFeedTheCow({
    required String accountID,
    required String cowID,
  }) async {
    String functionName = "feed_the_cow";

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
      functionName,
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

      Status status = Status.fail;
      int lastFedLedger = 0;

      for (XdrSCMapEntry v in resVal.map!) {
        if (v.key.sym == null) continue;
        if (v.key.sym == 'status' && v.val.vec != null) {
          status = (v.val.vec?.first.sym ?? '').getStatus();
        }
        if (v.key.sym == 'ledger' && v.val.u32 != null) {
          lastFedLedger = v.val.u32?.uint32 ?? 0;
        }
      }

      return (FeedTheCowResult(status: status, lastFedLedger: lastFedLedger), null);
    }

    return (FeedTheCowResult.zero(), AppMessages.processFails);
  }

  /// [invokeGetAllCow]
  /// call get_all_cow function on Cowchain Farm Soroban contract
  static Future<(GetAllCowResult, String?)> invokeGetAllCow({
    required String accountID,
  }) async {
    String functionName = "get_all_cow";

    // Retrieve Account Information
    AccountResponse account = await sdk.accounts.account(accountID);

    // ! The arguments ORDER must be EXACTLY the SAME as the order of Soroban Function Arguments
    List<XdrSCVal> arguments = [
      XdrSCVal.forAccountAddress(accountID),
    ];

    // Build Operation
    InvokeContractHostFunction hostFunction = InvokeContractHostFunction(
      getContractID(),
      functionName,
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
    if (error != null) return (GetAllCowResult.zero(), error.message);

    // Process Response
    txResponse = txResponse as GetTransactionResponse;
    if (server.enableLogging) {
      debugPrint('Transaction Response status: ${txResponse.status}');
    }

    if (txResponse.status == GetTransactionResponse.STATUS_SUCCESS) {
      XdrSCVal? resVal = txResponse.getResultValue();
      if (resVal == null || resVal.map == null) {
        return (GetAllCowResult.zero(), AppMessages.noResult);
      }

      Status status = Status.fail;
      List<CowData> cowData = [];

      for (XdrSCMapEntry v in resVal.map!) {
        if (v.key.sym == null) continue;
        if (v.key.sym == 'status' && v.val.vec != null) {
          status = (v.val.vec?.first.sym ?? '').getStatus();
        }
        if (v.key.sym == 'data' && v.val.vec != null) {
          for (XdrSCVal data in v.val.vec!) {
            CowData cow = await getCowData(data.map!);
            cowData.add(cow);
          }
        }
      }

      return (GetAllCowResult(status: status, data: cowData), null);
    }

    return (GetAllCowResult.zero(), AppMessages.processFails);
  }
}

/// [getCowData]
/// parse CowData object from Cowchain Farm Soroban contract
Future<CowData> getCowData(List<XdrSCMapEntry> mapEntries) async {
  CowData cow = CowData.zero();
  for (XdrSCMapEntry e in mapEntries) {
    if (e.key.sym == null) continue;
    if (e.key.sym == 'id') cow.cowId = e.val.str.toString();
    if (e.key.sym == 'name') cow.cowName = e.val.sym.toString();
    if (e.key.sym == 'breed') cow.breed = (e.val.u32?.uint32 ?? 0).getCowBreed();
    if (e.key.sym == 'born_ledger') cow.cowBornLedger = e.val.u32?.uint32 ?? 0;
    if (e.key.sym == 'last_fed_ledger') cow.cowLastFedLedger = e.val.u32?.uint32 ?? 0;
    if (e.key.sym == 'feeding_stats' && e.val.map != null) {
      CowFeedingStats cowStats = CowFeedingStats.zero();
      for (XdrSCMapEntry stats in e.val.map!) {
        if (stats.key.sym == 'on_time') cowStats.onTime = stats.val.u32?.uint32 ?? 0;
        if (stats.key.sym == 'late') cowStats.statsLate = stats.val.u32?.uint32 ?? 0;
        if (stats.key.sym == 'forget') cowStats.statsForget = stats.val.u32?.uint32 ?? 0;
      }
      cow.feedingStats = cowStats;
    }
  }
  return cow;
}
