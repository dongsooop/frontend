enum MarketType {
  SELL,
  BUY;

  String get label {
    switch (this) {
      case MarketType.SELL:
        return '판매';
      case MarketType.BUY:
        return '구매';
    }
  }
}
