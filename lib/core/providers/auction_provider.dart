import 'package:flutter/material.dart';

import '../models.dart';

class AuctionProvider extends ChangeNotifier {
  bool initialFetch = true;

  List<AuctionData> auctionList = [];

  void setInitialFetchStatus() {
    initialFetch = false;
  }

  void setNewAuctionData(List<AuctionData> newDataList) {
    auctionList = newDataList;
    notifyListeners();
  }

  void addNewAuctionData(AuctionData newData) {
    auctionList.add(newData);
    notifyListeners();
  }

  void updateAuctionDataList(AuctionData updatedAuctionData, String auctionID) {
    int index = auctionList.indexWhere((AuctionData v) => v.auctionId == auctionID);
    auctionList[index] = updatedAuctionData;
    notifyListeners();
  }

  void removeAuctionData(String auctionID) {
    int index = auctionList.indexWhere((AuctionData v) => v.auctionId == auctionID);
    auctionList.removeAt(index);
    notifyListeners();
  }
}
