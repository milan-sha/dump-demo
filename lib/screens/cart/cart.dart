class CartItem {
  String name;
  double price;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}

// THE GLOBAL LIST
List<CartItem> cartItems = [];

