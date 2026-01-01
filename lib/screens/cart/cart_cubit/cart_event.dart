abstract class CartEvent {}

// ... existing events (AddToCart, RemoveFromCart)

class UpdateQuantity extends CartEvent {
  final String productName;
  final bool isIncrement;
  UpdateQuantity(this.productName, this.isIncrement);
}

class ClearCart extends CartEvent {} // Added to reset cart after checkout