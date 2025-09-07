class ProductModel {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final double price;
  final List<Map<String, List<Map<String, dynamic>>>> specifications;
  final List<Map<String, dynamic>> selectedAddOns; // 👈 Now pricy add-ons
  final List<String> images;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.specifications,
    required this.selectedAddOns,
    required this.images,
  });

  /// ✅ Calculate the total price for this product
  /// [selectedSpecs] → Map<specName, optionName>
  /// [addOns] → Map<addonName, bool>
  /// [quantity] → number of items
  double calculateTotalPrice({
    required Map<String, String> selectedSpecs,
    required Map<String, bool> addOns,
    int quantity = 1,
  }) {
    double total = price;

    // Add specification extra prices
    for (var spec in specifications) {
      final key = spec.keys.first;
      final values = spec[key] ?? [];
      final selectedName = selectedSpecs[key];

      final selectedValue = values.firstWhere(
        (v) => v["name"] == selectedName,
        // orElse: () => null,
      );

      if (selectedValue != null) {
        total += (selectedValue["price"] ?? 0.0) as double;
      }
    }

    // Add selected add-ons
    for (var entry in addOns.entries) {
      if (entry.value) {
        final addon = selectedAddOns.firstWhere(
          (a) => a["name"] == entry.key,
          // orElse: () => null,
        );
        if (addon != null) {
          total += (addon["price"] ?? 0.0) as double;
        }
      }
    }

    return total * quantity;
  }
}
