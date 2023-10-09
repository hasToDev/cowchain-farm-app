import 'dart:async';

import 'package:flutter/material.dart';

import '../../contracts/cow_contract.dart';
import '../models.dart';

class CowProvider extends ChangeNotifier {
  Timer? periodicUpdate;
  int sequence = 0;
  bool isLoggedIn = false;
  String accountID = '';
  List<CowData> cows = [];
  List<String> ownership = [];

  bool userLoggedIn(String publicKey) {
    isLoggedIn = true;
    accountID = publicKey;
    return true;
  }

  bool userLoggedOut() {
    if (periodicUpdate != null) {
      periodicUpdate!.cancel();
      periodicUpdate = null;
    }
    isLoggedIn = false;
    accountID = '';
    sequence = 0;
    cows.clear();
    ownership.clear();
    return true;
  }

  void addCow(CowData data) {
    cows.add(data);
    notifyListeners();
  }

  void removeCow(CowData data) {
    List<CowData> newCows = List.from(cows);
    newCows.removeWhere((CowData v) => v.id == data.id);
    cows = newCows;
    notifyListeners();
  }

  void updateCowLastFed(CowData data, int newLastFedLedger) {
    if (newLastFedLedger == 0) return;
    int index = cows.indexWhere((CowData v) => v.id == data.id);
    cows[index].cowLastFedLedger = newLastFedLedger;
    sequence = newLastFedLedger;
    notifyListeners();
  }

  void updateCowDataList(List<CowData> cowList) {
    cows = cowList;
    notifyListeners();
  }

  void updateSequence(int latestSequence) {
    sequence = latestSequence;
    notifyListeners();
  }

  void updateOwnership(List<String> newOwnership) => ownership = newOwnership;

  void sequencePeriodicUpdate() {
    if (periodicUpdate != null) return;
    periodicUpdate = Timer.periodic(const Duration(seconds: 30), (_) async {
      int sequence = await CowContract.getLatestLedgerSequence();
      if (sequence != 0) updateSequence(sequence);
    });
  }
}
