import 'package:flutter/material.dart';
import 'enums.dart';

extension BuildContextX on BuildContext {
  /// [style] shorten syntax for textTheme
  TextTheme get style => Theme.of(this).textTheme;
}

extension CowBreedIntX on int {
  /// [getCowBreed] retrieve CowBreed based on int value
  CowBreed getCowBreed() {
    return switch (this) {
      1 => CowBreed.jersey,
      2 => CowBreed.limousin,
      3 => CowBreed.hallikar,
      4 => CowBreed.hereford,
      5 => CowBreed.holstein,
      6 => CowBreed.simmental,
      _ => CowBreed.jersey,
    };
  }
}

extension CowGenderIntX on int {
  /// [getCowGender] retrieve CowGender based on int value
  CowGender getCowGender() {
    return switch (this) {
      1 => CowGender.male,
      2 => CowGender.female,
      _ => CowGender.male,
    };
  }
}

extension CowBreedStringX on CowBreed {
  /// [name] retrieve CowBreed string value
  String name() {
    return switch (this) {
      CowBreed.jersey => 'Jersey',
      CowBreed.limousin => 'Limousin',
      CowBreed.hallikar => 'Hallikar',
      CowBreed.hereford => 'Hereford',
      CowBreed.holstein => 'Holstein',
      CowBreed.simmental => 'Simmental',
    };
  }

  /// [price] retrieve CowBreed price
  String price() {
    return switch (this) {
      CowBreed.jersey => '1000 XLM',
      CowBreed.limousin => '1000 XLM',
      CowBreed.hallikar => '1000 XLM',
      CowBreed.hereford => '5000 XLM',
      CowBreed.holstein => '15000 XLM',
      CowBreed.simmental => '15000 XLM',
    };
  }

  /// [imageURL] retrieve CowBreed image asset path
  String imageURL() {
    return switch (this) {
      CowBreed.jersey => 'assets/jersey.png',
      CowBreed.limousin => 'assets/limousin.png',
      CowBreed.hallikar => 'assets/hallikar.png',
      CowBreed.hereford => 'assets/hereford.png',
      CowBreed.holstein => 'assets/holstein.png',
      CowBreed.simmental => 'assets/simmental.png',
    };
  }
}

extension StatusX on String {
  /// [getStatus] retrieve Status based on String value
  Status getStatus() {
    return switch (this) {
      'Ok' => Status.ok,
      'Fail' => Status.fail,
      'AlreadyInitialized' => Status.alreadyInitialized,
      'NotInitialized' => Status.notInitialized,
      'TryAgain' => Status.tryAgain,
      'NotFound' => Status.notFound,
      'Found' => Status.found,
      'Saved' => Status.saved,
      'Bumped' => Status.bumped,
      'Upgraded' => Status.upgraded,
      'Duplicate' => Status.duplicate,
      'InsufficientFund' => Status.insufficientFund,
      'Underage' => Status.underage,
      'MissingOwnership' => Status.missingOwnership,
      'FullStomach' => Status.fullStomach,
      'OnAuction' => Status.onAuction,
      'BidIsClosed' => Status.bidIsClosed,
      'BidIsOpen' => Status.bidIsOpen,
      'CannotBidLower' => Status.cannotBidLower,
      'NameAlreadyExist' => Status.nameAlreadyExist,
      _ => Status.fail,
    };
  }
}
