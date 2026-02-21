extension PriceFormatter on num {
  String toPrice() {
    return "\$${toStringAsFixed(2)}";
  }
}
