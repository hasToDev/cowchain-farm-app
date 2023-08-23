import 'dart:async';

import 'package:cowchain_farm/helpers/js_stub_helper.dart'
    if (dart.library.html) 'package:js/js.dart';

import '../core/models.dart';
import '../core/type_definitions.dart';

class FreighterHelper {
  FreighterHelper._();

  static Duration timeOut = const Duration(seconds: 25);

  /// [isConnected]
  /// connect to Freighter using [_freighterIsConnected] and [_isConnectedCallback]
  static Future<(bool?, FreighterTimeout)> isConnected() async {
    Completer<(bool?, FreighterTimeout)>? isConnectedCompleter =
        Completer<(bool?, FreighterTimeout)>();
    // set timeout
    Timer timerTimeOut = Timer(timeOut, () {
      if (!isConnectedCompleter.isCompleted) {
        isConnectedCompleter.complete((null, true));
      }
    });
    // setup completer
    _isConnectedCallback = allowInterop((bool output) {
      if (!isConnectedCompleter.isCompleted) {
        timerTimeOut.cancel();
        isConnectedCompleter.complete((output, false));
      }
    });
    // call Freighter function
    _freighterIsConnected();
    // wait for result
    return isConnectedCompleter.future;
  }

  /// [isAllowed]
  /// connect to Freighter using [_freighterIsAllowed] and [_isAllowedCallback]
  static Future<(bool?, FreighterTimeout)> isAllowed() async {
    Completer<(bool?, FreighterTimeout)>? isAllowedCompleter =
        Completer<(bool?, FreighterTimeout)>();
    // set timeout
    Timer timerTimeOut = Timer(timeOut, () {
      if (!isAllowedCompleter.isCompleted) {
        isAllowedCompleter.complete((null, true));
      }
    });
    // setup completer
    _isAllowedCallback = allowInterop((bool output) {
      if (!isAllowedCompleter.isCompleted) {
        timerTimeOut.cancel();
        isAllowedCompleter.complete((output, false));
      }
    });
    // call Freighter function
    _freighterIsAllowed();
    // wait for result
    return isAllowedCompleter.future;
  }

  /// [getNetworkDetails]
  /// connect to Freighter using [_freighterGetNetworkDetails] and [_getNetworkDetailsCallback]
  static Future<(FreighterNetworkDetails?, FreighterTimeout)> getNetworkDetails() async {
    Completer<(FreighterNetworkDetails?, FreighterTimeout)>? getNetworkDetailsCompleter =
        Completer<(FreighterNetworkDetails?, FreighterTimeout)>();
    // set timeout
    Timer timerTimeOut = Timer(timeOut, () {
      if (!getNetworkDetailsCompleter.isCompleted) {
        getNetworkDetailsCompleter.complete((null, true));
      }
    });
    // setup completer
    _getNetworkDetailsCallback = allowInterop((network, networkUrl, networkPassphrase) {
      if (!getNetworkDetailsCompleter.isCompleted) {
        timerTimeOut.cancel();

        FreighterNetworkDetails detail = FreighterNetworkDetails(
          network: network,
          networkUrl: networkUrl,
          networkPassphrase: networkPassphrase,
        );
        getNetworkDetailsCompleter.complete((detail, false));
      }
    });
    // call Freighter function
    _freighterGetNetworkDetails();
    // wait for result
    return getNetworkDetailsCompleter.future;
  }

  /// [getPublicKey]
  /// connect to Freighter using [_freighterGetPublicKey] and [_getPublicKeyCallback]
  static Future<(String?, FreighterTimeout)> getPublicKey() async {
    Completer<(String?, FreighterTimeout)>? getPublicKeyCompleter =
        Completer<(String?, FreighterTimeout)>();
    // set timeout
    Timer timerTimeOut = Timer(timeOut, () {
      if (!getPublicKeyCompleter.isCompleted) {
        getPublicKeyCompleter.complete((null, true));
      }
    });
    // setup completer
    _getPublicKeyCallback = allowInterop((String output) {
      if (!getPublicKeyCompleter.isCompleted) {
        timerTimeOut.cancel();
        getPublicKeyCompleter.complete((output, false));
      }
    });
    // call Freighter function
    _freighterGetPublicKey();
    // wait for result
    return getPublicKeyCompleter.future;
  }

  /// [setAllowed]
  /// connect to Freighter using [_freighterSetAllowed] and [_setAllowedCallback]
  static Future<(bool?, FreighterTimeout)> setAllowed() async {
    Completer<(bool?, FreighterTimeout)>? setAllowedCompleter =
        Completer<(bool?, FreighterTimeout)>();
    // set timeout
    Timer timerTimeOut = Timer(timeOut, () {
      if (!setAllowedCompleter.isCompleted) {
        setAllowedCompleter.complete((null, true));
      }
    });
    // setup completer
    _setAllowedCallback = allowInterop((bool output) {
      if (!setAllowedCompleter.isCompleted) {
        timerTimeOut.cancel();
        setAllowedCompleter.complete((output, false));
      }
    });
    // call Freighter function
    _freighterSetAllowed();
    // wait for result
    return setAllowedCompleter.future;
  }

  /// [signTransaction]
  /// connect to Freighter using [_freighterSignTransaction] and [_signTransactionCallback]
  static Future<(String?, FreighterTimeout)> signTransaction(
    String transactionXDR,
    String network,
    String networkPassphrase,
    String accountToSign,
  ) async {
    Completer<(String?, FreighterTimeout)>? signTransactionCompleter =
        Completer<(String?, FreighterTimeout)>();
    // set timeout
    Timer timerTimeOut = Timer(timeOut, () {
      if (!signTransactionCompleter.isCompleted) {
        signTransactionCompleter.complete((null, true));
      }
    });
    // setup completer
    _signTransactionCallback = allowInterop((String output) {
      if (!signTransactionCompleter.isCompleted) {
        timerTimeOut.cancel();
        signTransactionCompleter.complete((output, false));
      }
    });
    // call Freighter function
    _freighterSignTransaction(transactionXDR, network, networkPassphrase, accountToSign);
    // wait for result
    return signTransactionCompleter.future;
  }
}

/// [_freighterIsConnected] should match js function
/// [_freighterIsConnected] must be used along with [_isConnectedCallback]
@JS()
external dynamic _freighterIsConnected();

/// should match callback name
@JS('isConnectedCallback')
external set _isConnectedCallback(void Function(bool output) f);

/// [_freighterIsAllowed] should match js function
/// [_freighterIsAllowed] must be used along with [_isAllowedCallback]
@JS()
external dynamic _freighterIsAllowed();

/// should match callback name
@JS('isAllowedCallback')
external set _isAllowedCallback(void Function(bool output) f);

/// [_freighterGetNetworkDetails] should match js function
/// [_freighterGetNetworkDetails] must be used along with [_getNetworkDetailsCallback]
@JS()
external dynamic _freighterGetNetworkDetails();

/// should match callback name
@JS('getNetworkDetailsCallback')
external set _getNetworkDetailsCallback(
    void Function(String network, String networkUrl, String networkPassphrase) f);

/// [_freighterGetPublicKey] should match js function
/// [_freighterGetPublicKey] must be used along with [_getPublicKeyCallback]
@JS()
external dynamic _freighterGetPublicKey();

/// should match callback name
@JS('getPublicKeyCallback')
external set _getPublicKeyCallback(void Function(String output) f);

/// [_freighterSetAllowed] should match js function
/// [_freighterSetAllowed] must be used along with [_setAllowedCallback]
@JS()
external dynamic _freighterSetAllowed();

/// should match callback name
@JS('setAllowedCallback')
external set _setAllowedCallback(void Function(bool output) f);

/// [_freighterSignTransaction] should match js function
/// [_freighterSignTransaction] must be used along with [_signTransactionCallback]
@JS()
external dynamic _freighterSignTransaction(
  String transactionXDR,
  String network,
  String networkPassphrase,
  String accountToSign,
);

/// should match callback name
@JS('signTransactionCallback')
external set _signTransactionCallback(void Function(String output) f);
