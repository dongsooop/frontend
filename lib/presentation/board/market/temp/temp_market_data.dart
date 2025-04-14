final List<Map<String, dynamic>> marketList = [
  {
    "market_img": "assets/images/market_test.png",
    "market_title": "DB 프로그래밍 교재",
    "market_created_at": DateTime(2025, 3, 4, 15, 0),
    "market_prices": "10,000",
    "market_messages": "3",
  },
  {
    "market_img": "",
    "market_title": "자바 프로그래밍 교재",
    "market_created_at": DateTime.now().subtract(Duration(hours: 3)), // 3시간 전
    "market_prices": "12,000",
    "market_messages": "5",
  },
  {
    "market_img": "assets/images/market_test.png",
    "market_title": "SCU 족보",
    "market_created_at":
        DateTime.now().subtract(Duration(minutes: 30)), // 30분 전
    "market_prices": "5,000",
    "market_messages": "1",
  },
  {
    "market_img": "",
    "market_title": "운영체제 실습 족보",
    "market_created_at":
        DateTime.now().subtract(Duration(days: 1, hours: 2)), // 1일 2시간 전
    "market_prices": "8,000",
    "market_messages": "7",
  },
  {
    "market_img": "assets/images/market_test.png",
    "market_title": "파이썬 문제집",
    "market_created_at": DateTime.now().subtract(Duration(days: 4)), // 4일 전
    "market_prices": "6,000",
    "market_messages": "0",
  },
];
