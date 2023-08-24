import 'package:cowchain_farm/helpers/js_stub_helper.dart'
    if (dart.library.html) 'package:js/js.dart';

import 'freighter_helper.dart';

/// JS Interop Annotation for [FreighterHelper.isConnected]
/// [freighterIsConnected] should match js function name
/// [isConnectedCallback] should match js callback name
///
@JS()
external dynamic freighterIsConnected();

@JS('isConnectedCallback')
external set isConnectedCallback(void Function(bool output) f);

/// JS Interop Annotation for [FreighterHelper.isAllowed]
/// [freighterIsAllowed] should match js function name
/// [isAllowedCallback] should match js callback name
///
@JS()
external dynamic freighterIsAllowed();

@JS('isAllowedCallback')
external set isAllowedCallback(void Function(bool output) f);

/// JS Interop Annotation for [FreighterHelper.getNetworkDetails]
/// [freighterGetNetworkDetails] should match js function name
/// [getNetworkDetailsCallback] should match js callback name
///
@JS()
external dynamic freighterGetNetworkDetails();

@JS('getNetworkDetailsCallback')
external set getNetworkDetailsCallback(
    void Function(String network, String networkUrl, String networkPassphrase) f);

/// JS Interop Annotation for [FreighterHelper.getPublicKey]
/// [freighterGetPublicKey] should match js function name
/// [getPublicKeyCallback] should match js callback name
///
@JS()
external dynamic freighterGetPublicKey();

@JS('getPublicKeyCallback')
external set getPublicKeyCallback(void Function(String output) f);

/// JS Interop Annotation for [FreighterHelper.setAllowed]
/// [freighterSetAllowed] should match js function name
/// [setAllowedCallback] should match js callback name
///
@JS()
external dynamic freighterSetAllowed();

@JS('setAllowedCallback')
external set setAllowedCallback(void Function(bool output) f);

/// JS Interop Annotation for [FreighterHelper.signTransaction]
/// [freighterSignTransaction] should match js function name
/// [signTransactionCallback] should match js callback name
///
@JS()
external dynamic freighterSignTransaction(
  String transactionXDR,
  String network,
  String networkPassphrase,
  String accountToSign,
);

@JS('signTransactionCallback')
external set signTransactionCallback(void Function(String output) f);
