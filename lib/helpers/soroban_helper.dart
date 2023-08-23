import 'package:cowchain_farm/main.dart';
import 'package:flutter/foundation.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

const String futureNetwork = 'FUTURENET';
const String futurePassphrase = 'Test SDF Future Network ; October 2022';

class SorobanHelper {
  SorobanHelper._();

  static Future<(GetTransactionResponse?, FormatException?)> submitTx({
    required SorobanServer server,
    required InvokeHostFunctionOperation operation,
    required AccountResponse account,
    required bool useAuth,
    KeyPair? keypair,
  }) async {
    // Build Transaction
    Transaction transaction = TransactionBuilder(account).addOperation(operation).build();

    // Simulate Transaction
    SimulateTransactionResponse simulateResponse = await server.simulateTransaction(transaction);
    if (simulateResponse.resultError?.contains('Error') ?? false) {
      if (server.enableLogging) {
        debugPrint('simulateResponse Error: ${simulateResponse.jsonResponse['result']['error']}');
      }
      return (null, FormatException(AppMessages.tryAgain));
    }

    transaction.addResourceFee((simulateResponse.minResourceFee ?? 440000000) * 2);
    transaction.sorobanTransactionData = simulateResponse.transactionData;
    if (useAuth) transaction.setSorobanAuth(simulateResponse.sorobanAuth);

    if (kIsWeb) {
      // Sign Transaction using Freighter
      var (List<XdrDecoratedSignature>? signatures, FreighterError? error) =
          await requestAuthFromFreighter(
              transaction: transaction, accountIDToSign: account.accountId, isFutureNet: true);
      if (error != null) return _freighterErrorHandler(error);
      transaction.signatures = signatures!;
    } else {
      // Sign Transaction using Keypair
      if (keypair == null) return (null, FormatException(AppMessages.provideSecretKey));
      transaction.sign(keypair, Network.FUTURENET);
    }

    // Send Transaction
    SendTransactionResponse sendTransactionResponse = await server.sendTransaction(transaction);

    // Check for errors in Send Transaction response
    var (GetTransactionResponse? _, FormatException? checkError) =
        _sendTransactionResponseCheck(sendTransactionResponse, server.enableLogging);
    if (checkError != null) return (null, checkError);

    // Poll Transaction Response
    return await PollStatusHelper.get(server, sendTransactionResponse.hash!);
  }

  static Future<(List<XdrDecoratedSignature>?, FreighterError?)> requestAuthFromFreighter({
    required Transaction transaction,
    required String accountIDToSign,
    required bool isFutureNet,
  }) async {
    // * is Freighter Connected
    var (bool? isConnected, FreighterTimeout isConnectedTimeout) =
        await FreighterHelper.isConnected();
    if (isConnectedTimeout) return (null, FreighterError.timeout);
    if (!isConnected!) {
      return (null, FreighterError.disconnect);
    }

    // * is Freighter Allowed
    var (bool? isAllowed, FreighterTimeout isAllowedTimeout) = await FreighterHelper.isAllowed();
    if (isAllowedTimeout) return (null, FreighterError.timeout);
    if (!isAllowed!) {
      // * allow access Freighter
      var (bool? setAllowed, FreighterTimeout setAllowedTimeout) =
          await FreighterHelper.setAllowed();
      if (setAllowedTimeout) return (null, FreighterError.timeout);
      if (!setAllowed!) {
        return (null, FreighterError.accessDenied);
      }
    }

    // * get Freighter Network Details
    var (FreighterNetworkDetails? getNetworkDetails, FreighterTimeout networkDetailsTimeout) =
        await FreighterHelper.getNetworkDetails();
    if (networkDetailsTimeout) return (null, FreighterError.timeout);

    String network = getNetworkDetails!.network;
    String networkPassphrase = getNetworkDetails.networkPassphrase;

    if (isFutureNet) {
      if (network != futureNetwork) network = futureNetwork;
      if (networkPassphrase != futurePassphrase) networkPassphrase = futurePassphrase;
    }

    // * sign transaction with Freighter
    var (String? signedTx, FreighterTimeout signedTxTimeout) =
        await FreighterHelper.signTransaction(
      transaction.toEnvelopeXdrBase64(),
      network,
      networkPassphrase,
      accountIDToSign,
    );
    if (signedTxTimeout) return (null, FreighterError.timeout);
    if (signedTx!.isEmpty) {
      return (null, FreighterError.signTxDenied);
    }

    // * get signatures
    List<XdrDecoratedSignature>? signatures =
        XdrTransactionEnvelope.fromEnvelopeXdrString(signedTx).v1?.signatures;
    if (signatures == null) {
      return (null, FreighterError.noSignatureFound);
    }
    return (signatures, null);
  }

  static (GetTransactionResponse?, FormatException?) _freighterErrorHandler(FreighterError error) {
    String errMessage = '';
    switch (error) {
      case FreighterError.timeout:
        errMessage = AppMessages.timeoutFreighter;
      case FreighterError.disconnect:
        errMessage = AppMessages.connectFreighter;
      case FreighterError.accessDenied:
        errMessage = AppMessages.allowFreighterShareData;
      case FreighterError.signTxDenied:
        errMessage = AppMessages.allowFreighterSignTx;
      case FreighterError.noSignatureFound:
        errMessage = AppMessages.tryAgain;
    }
    return (null, FormatException(errMessage));
  }

  static (GetTransactionResponse?, FormatException?) _sendTransactionResponseCheck(
    SendTransactionResponse sendTransactionResponse,
    bool enableLogging,
  ) {
    // check for error
    if (sendTransactionResponse.error != null) {
      if (enableLogging) {
        debugPrint('sendTransactionResponse Error: ${sendTransactionResponse.error?.message}');
      }
      return (null, FormatException(AppMessages.tryAgain));
    }
    // check for hash
    if (sendTransactionResponse.hash == null) {
      if (enableLogging) {
        debugPrint('sendTransactionResponse Error: hash is null');
      }
      return (null, FormatException(AppMessages.tryAgain));
    }
    // check for status
    if (sendTransactionResponse.status == SendTransactionResponse.STATUS_ERROR ||
        sendTransactionResponse.status == SendTransactionResponse.STATUS_DUPLICATE ||
        sendTransactionResponse.status == SendTransactionResponse.STATUS_TRY_AGAIN_LATER) {
      if (enableLogging) {
        debugPrint(
            'sendTransactionResponse Error:\nStatus: ${sendTransactionResponse.status}\nXDR: ${sendTransactionResponse.errorResultXdr}');
      }
      return (null, FormatException(AppMessages.tryAgain));
    }
    return (null, null);
  }
}
