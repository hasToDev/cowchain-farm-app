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
      // TODO: Handle this case.
      case CowchainFunction.bidding:
      // TODO: Handle this case.
      case CowchainFunction.finalizeAuction:
      // TODO: Handle this case.
      case CowchainFunction.getAllAuction:
      // TODO: Handle this case.
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
      if (e.key.sym == 'breed') cow.breed = (e.val.u32?.uint32 ?? 0).getCowBreed();
      if (e.key.sym == 'gender') cow.gender = (e.val.u32?.uint32 ?? 0).getCowGender();
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
      if (e.key.sym == 'auction_id') cow.auctionId = e.val.str.toString();
    }
    return cow;
  }
}
