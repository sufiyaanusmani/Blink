class Order {
  final int orderID;
  final String restaurantName;
  final String status;
  final int price;

  /// Constructor for [Order]
  ///
  /// Parameters:
  ///   - orderID: [int]
  ///   - restaurantName: [String]
  ///   - status: [String]
  ///   - price: [int]
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// Order obj = Order(orderID, restaurantName, status, price);
  /// ```
  Order(
      {required this.orderID,
      required this.restaurantName,
      required this.status,
      required this.price});
}
