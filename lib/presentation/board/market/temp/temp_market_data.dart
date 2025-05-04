final List<Map<String, dynamic>> marketList = [
  {
    "market_id": 1,
    "market_state": "거래 중",
    "market_title": "DB 프로그래밍 교재",
    "market_created_at": DateTime.now().subtract(Duration(hours: 5)),
    "market_prices": "10,000",
    "market_messages": 3,
    "images": [
      "assets/images/market_test.png",
      "assets/images/market_test.png",
      "assets/images/market_test.png",
      "assets/images/market_test.png",
    ]
  },
  {
    "market_id": 2,
    "market_state": "판매 중",
    "market_title": "자바 프로그래밍 교재",
    "market_created_at": DateTime.now().subtract(Duration(hours: 3)),
    "market_prices": "12,000",
    "market_messages": 0,
    "images": [], // 이미지 없음
  },
  {
    "market_id": 3,
    "market_state": "판매 중",
    "market_title": "SCU 족보",
    "market_created_at": DateTime.now().subtract(Duration(minutes: 30)),
    "market_prices": "5,000",
    "market_messages": 0,
    "images": ["assets/images/market_test.png"],
  },
  {
    "market_id": 4,
    "market_state": "거래 완료",
    "market_title": "운영체제 실습 족보",
    "market_created_at": DateTime.now().subtract(Duration(days: 1, hours: 2)),
    "market_prices": "8,000",
    "market_messages": 14,
    "images": [],
  },
  {
    "market_id": 5,
    "market_state": "판매 중",
    "market_title": "파이썬 문제집",
    "market_created_at": DateTime.now().subtract(Duration(days: 4)),
    "market_prices": "6,000",
    "market_messages": 0,
    "images": ["assets/images/market_test.png"],
  },
];
