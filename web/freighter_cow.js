async function _freighterIsConnected() {
    try {
        var output = await window.freighterApi.isConnected();
        window.isConnectedCallback(output);
    } catch {
        window.isConnectedCallback(false);
    }
}

async function _freighterIsAllowed() {
    try {
        var output = await window.freighterApi.isAllowed();
        window.isAllowedCallback(output);
    } catch {
        window.isAllowedCallback(false);
    }
}

async function _freighterGetNetworkDetails() {
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

async function _freighterGetPublicKey() {
    try {
        var output = await window.freighterApi.getPublicKey();
        window.getPublicKeyCallback(output);
    } catch {
        window.getPublicKeyCallback("");
    }
}

async function _freighterSetAllowed() {
    try {
        var output = await window.freighterApi.setAllowed();
        window.setAllowedCallback(output);
    } catch {
        window.setAllowedCallback(false);
    }
}

async function _freighterSignTransaction(
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
