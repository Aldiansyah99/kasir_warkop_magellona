// To parse this JSON data, do
//
//     final report = reportFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

String reportToJson(Report data) => json.encode(data.toJson());

class Report extends Equatable {
  Report({
    this.data,
  });

  final Data data;

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };

  @override
  List<Object> get props => [data];
}

class Data extends Equatable {
  Data({
    this.totalProduct,
    this.totalTransaction,
    this.totalAdmin,
    this.transaction,
  });

  final int totalProduct;
  final int totalTransaction;
  final int totalAdmin;
  final List<TransactionReport> transaction;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalProduct: json["total_product"],
        totalTransaction: json["total_transaction"],
        totalAdmin: json["total_admin"],
        transaction: List<TransactionReport>.from(
            json["transaction"].map((x) => TransactionReport.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_product": totalProduct,
        "total_transaction": totalTransaction,
        "total_admin": totalAdmin,
        "transaction": List<dynamic>.from(transaction.map((x) => x.toJson())),
      };

  @override
  List<Object> get props => [
        totalProduct,
        totalTransaction,
        totalAdmin,
        transaction,
      ];
}

class TransactionReport extends Equatable {
  TransactionReport({
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

  factory TransactionReport.fromJson(Map<String, dynamic> json) =>
      TransactionReport(
        id: json["id"],
        invoice: json["invoice"],
        tanggal: DateTime.parse(json["tanggal"]),
        meja: json["meja"],
        wa: json["wa"] == null ? null : json["wa"],
        email: json["email"] == null ? null : json["email"],
        total: json["total"],
        status: json["status"],
        bayar: json["bayar"] == null ? null : json["bayar"],
        kembalian: json["kembalian"] == null ? null : json["kembalian"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice": invoice,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "meja": meja,
        "wa": wa == null ? null : wa,
        "email": email == null ? null : email,
        "total": total,
        "status": status,
        "bayar": bayar == null ? null : bayar,
        "kembalian": kembalian == null ? null : kembalian,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
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
      ];
}
