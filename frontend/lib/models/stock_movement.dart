import 'dart:convert';

List<StockMovement> stockMovementFromJson(String str) => 
    List<StockMovement>.from(json.decode(str).map((x) => StockMovement.fromJson(x)));

String stockMovementToJson(List<StockMovement> data) => 
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StockMovement {
  final int? stockMovementId;
  final int productId;
  final String movementType;
  final int quantity;
  final String movementDate;
  final String notes;

  StockMovement({
    this.stockMovementId,
    required this.productId,
    required this.movementType,
    required this.quantity,
    required this.movementDate,
    required this.notes,
  });

  factory StockMovement.fromJson(Map<String, dynamic> json) {
    return StockMovement(
      stockMovementId: json['stockMovementId'],
      productId: json['productId'],
      movementType: json['movementType'],
      quantity: json['quantity'],
      movementDate: json['movementDate'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stockMovementId': stockMovementId,
      'productId': productId,
      'movementType': movementType,
      'quantity': quantity,
      'movementDate': movementDate,
      'notes': notes,
    };
  }

  StockMovement copyWith({
    int? stockMovementId,
    int? productId,
    String? movementType,
    int? quantity,
    String? movementDate,
    String? notes,
  }) {
    return StockMovement(
      stockMovementId: stockMovementId ?? this.stockMovementId,
      productId: productId ?? this.productId,
      movementType: movementType ?? this.movementType,
      quantity: quantity ?? this.quantity,
      movementDate: movementDate ?? this.movementDate,
      notes: notes ?? this.notes,
    );
  }
}
