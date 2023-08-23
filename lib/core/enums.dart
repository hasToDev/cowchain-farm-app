enum FreighterError {
  timeout,
  disconnect,
  accessDenied,
  signTxDenied,
  noSignatureFound,
}

enum CowBreed {
  jersey,
  limousin,
  hallikar,
  hereford,
  holstein,
  simmental,
}

enum Status {
  ok,
  fail,
  alreadyInitialized,
  notInitialized,
  tryAgain,
  notFound,
  found,
  saved,
  bumped,
  upgraded,
  duplicate,
  insufficientFund,
  underage,
  missingOwnership,
  fullStomach,
}
