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
  onAuction,
  bidIsClosed,
  bidIsOpen,
  cannotBidLower,
  nameAlreadyExist,
}

enum CowchainFunction {
  buyCow,
  sellCow,
  cowAppraisal,
  feedTheCow,
  getAllCow,
  registerAuction,
  bidding,
  finalizeAuction,
  getAllAuction,
}

enum CowGender {
  male,
  female,
}
