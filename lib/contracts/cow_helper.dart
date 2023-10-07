import 'package:cowchain_farm/main.dart';
import 'package:fixnum/fixnum.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

class CowHelper {
  CowHelper._();

  /// [parseResult]
  /// parse result value from Cowchain Farm Soroban contract
  static Future<dynamic> parseResult(CowchainFunction function, XdrSCVal resultValue) async {
    switch (function) {
      case CowchainFunction.buyCow:
        {
          Status status = Status.fail;
          List<CowData> cowData = [];
          List<String> ownershipData = [];

          for (XdrSCMapEntry v in resultValue.map!) {
            if (v.key.sym == null) continue;
            if (v.key.sym == 'status' && v.val.vec != null) {
              status = (v.val.vec?.first.sym ?? '').getStatus();
            }
            if (v.key.sym == 'cow_data' && v.val.vec != null) {
              for (XdrSCVal data in v.val.vec!) {
                CowData cow = await getCowData(data.map!);
                cowData.add(cow);
              }
            }
            if (v.key.sym == 'ownership' && v.val.vec != null) {
              for (XdrSCVal data in v.val.vec!) {
                ownershipData.add(data.str.toString());
              }
            }
          }

          return BuyCowResult(status: status, data: cowData, ownership: ownershipData);
        }
      case CowchainFunction.sellCow:
        {
          Status status = Status.fail;
          List<String> ownershipData = [];

          for (XdrSCMapEntry v in resultValue.map!) {
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

          return SellCowResult(status: status, ownership: ownershipData);
        }
      case CowchainFunction.cowAppraisal:
        {
          Status status = Status.fail;
          String price = '';

          for (XdrSCMapEntry v in resultValue.map!) {
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

          return CowAppraisalResult(status: status, price: price);
        }
      case CowchainFunction.feedTheCow:
        {
          Status status = Status.fail;
          int lastFedLedger = 0;

          for (XdrSCMapEntry v in resultValue.map!) {
            if (v.key.sym == null) continue;
            if (v.key.sym == 'status' && v.val.vec != null) {
              status = (v.val.vec?.first.sym ?? '').getStatus();
            }
            if (v.key.sym == 'ledger' && v.val.u32 != null) {
              lastFedLedger = v.val.u32?.uint32 ?? 0;
            }
          }

          return FeedTheCowResult(status: status, lastFedLedger: lastFedLedger);
        }
      case CowchainFunction.getAllCow:
        {
          Status status = Status.fail;
          List<CowData> cowData = [];

          for (XdrSCMapEntry v in resultValue.map!) {
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

          return GetAllCowResult(status: status, data: cowData);
        }
      case CowchainFunction.registerAuction:
      case CowchainFunction.bidding:
      case CowchainFunction.finalizeAuction:
      case CowchainFunction.getAllAuction:
        {
          Status status = Status.fail;
          List<AuctionData> auctionData = [];

          for (XdrSCMapEntry v in resultValue.map!) {
            if (v.key.sym == null) continue;
            if (v.key.sym == 'status' && v.val.vec != null) {
              status = (v.val.vec?.first.sym ?? '').getStatus();
            }
            if (v.key.sym == 'auction_data' && v.val.vec != null) {
              for (XdrSCVal data in v.val.vec!) {
                AuctionData auction = await getAuctionData(data.map!);
                auctionData.add(auction);
              }
            }
          }

          return AuctionResult(status: status, auctionData: auctionData);
        }
    }
  }

  /// [getCowData]
  /// parse CowData object from Cowchain Farm Soroban contract
  static Future<CowData> getCowData(List<XdrSCMapEntry> mapEntries) async {
    CowData cow = CowData.zero();
    for (XdrSCMapEntry e in mapEntries) {
      if (e.key.sym == null) continue;
      if (e.key.sym == 'id') cow.cowId = e.val.str.toString();
      if (e.key.sym == 'name') cow.cowName = e.val.sym.toString();
      if (e.key.sym == 'breed') cow.cowBreed = (e.val.u32?.uint32 ?? 0).getCowBreed();
      if (e.key.sym == 'gender') cow.cowGender = (e.val.u32?.uint32 ?? 0).getCowGender();
      if (e.key.sym == 'born_ledger') cow.cowBornLedger = e.val.u32?.uint32 ?? 0;
      if (e.key.sym == 'last_fed_ledger') cow.cowLastFedLedger = e.val.u32?.uint32 ?? 0;
      if (e.key.sym == 'feeding_stats' && e.val.map != null) {
        CowFeedingStats cowStats = CowFeedingStats.zero();
        for (XdrSCMapEntry stats in e.val.map!) {
          if (stats.key.sym == 'on_time') cowStats.onTime = stats.val.u32?.uint32 ?? 0;
          if (stats.key.sym == 'late') cowStats.statsLate = stats.val.u32?.uint32 ?? 0;
          if (stats.key.sym == 'forget') cowStats.statsForget = stats.val.u32?.uint32 ?? 0;
        }
        cow.cowFeedingStats = cowStats;
      }
      if (e.key.sym == 'auction_id') cow.cowAuctionId = e.val.str.toString();
    }
    return cow;
  }

  /// [getAuctionData]
  /// parse AuctionData object from Cowchain Farm Soroban contract
  static Future<AuctionData> getAuctionData(List<XdrSCMapEntry> mapEntries) async {
    AuctionData auction = AuctionData.zero();
    for (XdrSCMapEntry e in mapEntries) {
      if (e.key.sym == null) continue;
      if (e.key.sym == 'auction_id') auction.cowAuctionId = e.val.str.toString();
      if (e.key.sym == 'cow_id') auction.cowId = e.val.str.toString();
      if (e.key.sym == 'cow_name') auction.cowName = e.val.sym.toString();
      if (e.key.sym == 'cow_breed') auction.cowBreed = (e.val.u32?.uint32 ?? 0).getCowBreed();
      if (e.key.sym == 'cow_gender') auction.cowGender = (e.val.u32?.uint32 ?? 0).getCowGender();
      if (e.key.sym == 'cow_born_ledger') auction.cowBornLedger = e.val.u32?.uint32 ?? 0;
      if (e.key.sym == 'owner' && e.val.address != null) {
        auction.cowOwner = Address.fromXdr(e.val.address!);
      }
      if (e.key.sym == 'start_price' && e.val.i128 != null) {
        int high = e.val.i128?.hi.int64 ?? 0;
        int low = e.val.i128?.lo.uint64 ?? 0;
        Int64 price64 = (Int64(1000000000) * Int64(high)) + Int64(low);
        String price = (price64 ~/ Int64(10000000)).toString();
        if (price.isNotEmpty) auction.cowAuctionStartPrice = price;
      }
      if (e.key.sym == 'highest_bidder' && e.val.map != null) {
        auction.cowHighestBidder = await getBidder(e.val.map!);
      }
      if (e.key.sym == 'bid_history' && e.val.vec != null) {
        List<Bidder> bidHistory = [];
        for (XdrSCVal data in e.val.vec!) {
          Bidder bidder = await getBidder(data.map!);
          bidHistory.add(bidder);
        }
        auction.cowBidHistory = bidHistory;
      }
      if (e.key.sym == 'auction_limit_ledger') {
        auction.cowAuctionLimitLedger = e.val.u32?.uint32 ?? 0;
      }
    }
    return auction;
  }

  /// [getBidder]
  /// parse Bidder object from Cowchain Farm Soroban contract
  static Future<Bidder> getBidder(List<XdrSCMapEntry> mapEntries) async {
    Bidder bidder = Bidder.zero();
    for (XdrSCMapEntry e in mapEntries) {
      if (e.key.sym == 'user' && e.val.address != null) {
        bidder.cowUser = Address.fromXdr(e.val.address!);
      }
      if (e.key.sym == 'price' && e.val.i128 != null) {
        int high = e.val.i128?.hi.int64 ?? 0;
        int low = e.val.i128?.lo.uint64 ?? 0;
        Int64 price64 = (Int64(1000000000) * Int64(high)) + Int64(low);
        String price = (price64 ~/ Int64(10000000)).toString();
        if (price.isNotEmpty) bidder.cowPrice = price;
      }
    }
    return bidder;
  }

  /// [checkPreflightStatus]
  /// check preflight result from Cowchain Farm Soroban contract for its status
  static Future<(Status, String)> checkPreflightStatus(
      CowchainFunction function, XdrSCVal resultValue) async {
    // parse preflight result
    dynamic preParse = await parseResult(function, resultValue);

    // check preflight status
    Status preStatus = Status.ok;
    String preErrorMessage = '';

    switch (function) {
      case CowchainFunction.buyCow:
        preStatus = (preParse as BuyCowResult).status;
      case CowchainFunction.sellCow:
        {
          preStatus = (preParse as SellCowResult).status;
          if (preStatus == Status.notFound) preErrorMessage = AppMessages.cowNotFound;
          if (preStatus == Status.insufficientFund) {
            preErrorMessage = AppMessages.insufficientMarketFund;
          }
        }
      case CowchainFunction.cowAppraisal:
        {
          preStatus = (preParse as CowAppraisalResult).status;
          if (preStatus == Status.notFound) preErrorMessage = AppMessages.cowNotFound;
        }
      case CowchainFunction.feedTheCow:
        {
          preStatus = (preParse as FeedTheCowResult).status;
          if (preStatus == Status.notFound) preErrorMessage = AppMessages.cowNotFound;
        }
      case CowchainFunction.getAllCow:
        preStatus = Status.ok; // do nothing, will only give empty result
      case CowchainFunction.registerAuction:
        {
          preStatus = (preParse as AuctionResult).status;
          if (preStatus == Status.notFound) preErrorMessage = AppMessages.cowNotFound;
        }
      case CowchainFunction.bidding:
        preStatus = (preParse as AuctionResult).status;
      case CowchainFunction.finalizeAuction:
        preStatus = (preParse as AuctionResult).status;
      case CowchainFunction.getAllAuction:
        preStatus = Status.ok; // do nothing, will only give empty result
    }

    return (preStatus, preErrorMessage);
  }
}
