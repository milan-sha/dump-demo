class CartItem {
  String name;
  String image;
  double price;
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}

// Sample cart items
List<CartItem> cartItems = [
];