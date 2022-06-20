// To parse this JSON data, do
//
//     final listTransaction = listTransactionFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:si_pos/models/product.dart';

DataTransaction dataTransactionFromJson(String str) =>
    DataTransaction.fromJson(json.decode(str));

String dataTransactionToJson(DataTransaction data) =>
    json.encode(data.toJson());

class DataTransaction {
  DataTransaction({
    this.data,
  });

  final List<Datum> data;

  factory DataTransaction.fromJson(Map<String, dynamic> json) =>
      DataTransaction(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MDetailTransaction {
  MDetailTransaction({
    this.data,
  });

  final Datum data;

  factory MDetailTransaction.fromJson(Map<String, dynamic> json) =>
      MDetailTransaction(
        data: Datum.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Datum extends Equatable {
  Datum({
    this.id,
    this.invoice,
    this.tanggal,
    this.meja,
    this.wa,
    this.email,
    this.total,
    this.status,
    this.bayar,
    this.kembalian,
    this.createdAt,
    this.updatedAt,
    this.transcation,
  });

  final int id;
  final String invoice;
  final DateTime tanggal;
  final String meja;
  final String wa;
  final String email;
  final int total;
  final String status;
  final int bayar;
  final int kembalian;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Transcation> transcation;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        invoice: json["invoice"],
        tanggal: DateTime.parse(json["tanggal"]),
        meja: json["meja"],
        wa: json["wa"],
        email: json["email"] == null ? null : json["email"],
        total: json["total"],
        status: json["status"],
        bayar: json["bayar"] == null ? null : json["bayar"],
        kembalian: json["kembalian"] == null ? null : json["kembalian"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        transcation: List<Transcation>.from(
            json["transcation"].map((x) => Transcation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice": invoice,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "meja": meja,
        "wa": wa,
        "email": email == null ? null : email,
        "total": total,
        "status": status,
        "bayar": bayar == null ? null : bayar,
        "kembalian": kembalian == null ? null : kembalian,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "transcation": List<dynamic>.from(transcation.map((x) => x.toJson())),
      };

  @override
  List<Object> get props => [
        id,
        invoice,
        tanggal,
        meja,
        wa,
        email,
        total,
        status,
        bayar,
        kembalian,
        createdAt,
        updatedAt,
        transcation,
      ];
}

class Transcation extends Equatable {
  Transcation({
    this.id,
    this.transactionId,
    this.productsId,
    this.count,
    this.price,
    this.sellAt,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  final int id;
  final int transactionId;
  final String productsId;
  final int count;
  final int price;
  final DateTime sellAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product product;

  factory Transcation.fromJson(Map<String, dynamic> json) => Transcation(
        id: json["id"],
        transactionId: json["transaction_id"],
        productsId: json["products_id"],
        count: json["count"],
        price: json["price"],
        sellAt: DateTime.parse(json["sell_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product:
            json["produk"] == null ? null : Product.fromJson(json["produk"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "transaction_id": transactionId,
        "products_id": productsId,
        "count": count,
        "price": price,
        "sell_at":
            "${sellAt.year.toString().padLeft(4, '0')}-${sellAt.month.toString().padLeft(2, '0')}-${sellAt.day.toString().padLeft(2, '0')}",
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  @override
  List<Object> get props => [
        id,
        transactionId,
        productsId,
        count,
        price,
        sellAt,
        createdAt,
        updatedAt,
        product,
      ];
}
