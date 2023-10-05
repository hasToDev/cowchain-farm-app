import 'enums.dart';
import 'extensions.dart';

/// [FreighterNetworkDetails]
/// Network Details data from Freighter
class FreighterNetworkDetails {
  const FreighterNetworkDetails({
    required this.network,
    required this.networkUrl,
    required this.networkPassphrase,
  });

  final String network;
  final String networkUrl;
  final String networkPassphrase;
}

/// [CowData]
/// Cow Data object from Cowchain Farm Soroban contract
class CowData {
  CowData({
    required this.id,
    required this.name,
    required this.breed,
    required this.gender,
    required this.bornLedger,
    required this.lastFedLedger,
    required this.feedingStats,
    required this.auctionId,
  });

  late String id;
  late String name;
  late CowBreed breed;
  late CowGender gender;
  late int bornLedger;
  late int lastFedLedger;
  late CowFeedingStats feedingStats;
  late String auctionId;

  set cowId(String id) => this.id = id;
  set cowName(String name) => this.name = name;
  set cowBreed(CowBreed breed) => this.breed = breed;
  set cowGender(CowGender gender) => this.gender = gender;
  set cowBornLedger(int bornLedger) => this.bornLedger = bornLedger;
  set cowLastFedLedger(int lastFedLedger) => this.lastFedLedger = lastFedLedger;
  set cowFeedingStats(CowFeedingStats feedingStats) => this.feedingStats = feedingStats;
  set cowAuctionId(String auctionId) => this.auctionId = auctionId;

  static CowData zero() => CowData(
        id: '',
        name: '',
        breed: 0.getCowBreed(),
        gender: 0.getCowGender(),
        bornLedger: 0,
        lastFedLedger: 0,
        feedingStats: CowFeedingStats.zero(),
        auctionId: '',
      );
}

/// [CowFeedingStats]
/// Cow Feeding Stats object from Cowchain Farm Soroban contract
class CowFeedingStats {
  CowFeedingStats({
    required this.onTime,
    required this.late,
    required this.forget,
  });

  late int onTime;
  late int late;
  late int forget;

  set statsOnTime(int onTime) => this.onTime = onTime;
  set statsLate(int late) => this.late = late;
  set statsForget(int forget) => this.forget = forget;

  static CowFeedingStats zero() => CowFeedingStats(onTime: 0, late: 0, forget: 0);
}

/// [BuyCowResult]
/// Result for buy_cow function from Cowchain Farm Soroban contract
class BuyCowResult {
  const BuyCowResult({
    required this.status,
    required this.data,
    required this.ownership,
  });

  final Status status;
  final List<CowData> data;
  final List<String> ownership;

  static BuyCowResult zero() => const BuyCowResult(status: Status.fail, data: [], ownership: []);
}

/// [SellCowResult]
/// Result for sell_cow function from Cowchain Farm Soroban contract
class SellCowResult {
  const SellCowResult({
    required this.status,
    required this.ownership,
  });

  final Status status;
  final List<String> ownership;

  static SellCowResult zero() => const SellCowResult(status: Status.fail, ownership: []);
}

/// [CowAppraisalResult]
/// Result for cow_appraisal function from Cowchain Farm Soroban contract
class CowAppraisalResult {
  const CowAppraisalResult({
    required this.status,
    required this.price,
  });

  final Status status;
  final String price;

  static CowAppraisalResult zero() => const CowAppraisalResult(status: Status.fail, price: '');
}

/// [GetAllCowResult]
/// Result for get_all_cow function from Cowchain Farm Soroban contract
class GetAllCowResult {
  const GetAllCowResult({
    required this.status,
    required this.data,
  });

  final Status status;
  final List<CowData> data;

  static GetAllCowResult zero() => const GetAllCowResult(status: Status.fail, data: []);
}

/// [FeedTheCowResult]
/// Result for feed_the_cow function from Cowchain Farm Soroban contract
class FeedTheCowResult {
  const FeedTheCowResult({
    required this.status,
    required this.lastFedLedger,
  });

  final Status status;
  final int lastFedLedger;

  static FeedTheCowResult zero() => const FeedTheCowResult(status: Status.fail, lastFedLedger: 0);
}
