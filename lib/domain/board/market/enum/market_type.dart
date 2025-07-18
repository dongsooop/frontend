enum MarketType {
  SELL,
  BUY,
  REPORT;

  String get label {
    switch (this) {
      case MarketType.SELL:
        return '판매';
      case MarketType.BUY:
        return '구매';
      case MarketType.REPORT:
        return '장터';
    }
  }
}
