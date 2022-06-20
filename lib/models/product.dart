import 'package:equatable/equatable.dart';

class Product extends Equatable {
  Product({
    this.id,
    this.name,
    this.count,
    this.price,
    this.productsId,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final int count;
  final int price;
  final String productsId;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        count: json["count"],
        price: json["price"],
        productsId: json["products_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "count": count,
        "price": price,
        "products_id": productsId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  @override
  List<Object> get props => [
        id,
        name,
        count,
        price,
        productsId,
        createdAt,
        updatedAt,
      ];
}
