// freighter_helper.dart in Flutter uses all the JS code on this file.
// don't change the function or callback names without adjusting the Flutter code.

// for [FreighterHelper.isConnected]
//
async function freighterIsConnected() {
    try {
        var output = await window.freighterApi.isConnected();
        window.isConnectedCallback(output);
    } catch {
        window.isConnectedCallback(false);
    }
}

// for [FreighterHelper.isAllowed]
//
async function freighterIsAllowed() {
    try {
        var output = await window.freighterApi.isAllowed();
        window.isAllowedCallback(output);
    } catch {
        window.isAllowedCallback(false);
    }
}

// for [FreighterHelper.getNetworkDetails]
//
async function freighterGetNetworkDetails() {
    try {
        var output = await window.freighterApi.getNetworkDetails();
        window.getNetworkDetailsCallback(
            output.network,
            output.networkUrl,
            output.networkPassphrase,
        );
    } catch {
        window.getNetworkDetailsCallback("","","");
    }
}

// for [FreighterHelper.getPublicKey]
//
async function freighterGetPublicKey() {
    try {
        var output = await window.freighterApi.getPublicKey();
        window.getPublicKeyCallback(output);
    } catch {
        window.getPublicKeyCallback("");
    }
}

// for [FreighterHelper.setAllowed]
//
async function freighterSetAllowed() {
    try {
        var output = await window.freighterApi.setAllowed();
        window.setAllowedCallback(output);
    } catch {
        window.setAllowedCallback(false);
    }
}

// for [FreighterHelper.signTransaction]
//
async function freighterSignTransaction(
    transactionXDR,
    network,
    networkPassphrase,
    accountToSign,
) {
    try {
        var output = await window.freighterApi.signTransaction(
            transactionXDR,
            {network: network, networkPassphrase: networkPassphrase, accountToSign: accountToSign},
        );
        window.signTransactionCallback(output);
    } catch {
        window.signTransactionCallback("");
    }
}
