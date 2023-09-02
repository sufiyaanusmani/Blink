class Order {
  final int orderID;
  final String restaurantName;
  final String status;
  final int price;

  Order(
      {required this.orderID,
      required this.restaurantName,
      required this.status,
      required this.price});
}
