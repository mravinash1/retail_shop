class Item {
  final int id;
  final String name;
  final String unit;
  final double rate;
  final String barcode;

  Item({
    required this.id,
    required this.name,
    required this.unit,
    required this.barcode,
    required this.rate,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['ItemMaster']['id'],
      name: json['ItemMaster']['itname'],
      unit: json['unitname'],
      barcode: json['ItemMaster']['barcode'] ?? '', // ✅ Fix barcode
      rate: (json['ItemMaster']['restrate'] ?? 0).toDouble(), // ✅ Fix rate
    );
  }
}
