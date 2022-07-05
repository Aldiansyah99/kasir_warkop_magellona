part of 'services.dart';

class TransactionService {
  static Future<ApiReturnValue<DataTransaction>> getListTransaction() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('loginToken');

    Uri urlApi = Uri.parse('$url/api/auth/transaction-master');

    var response = await http.get(urlApi, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Terjadi kesalahan, coba lagi');
    }

    var data = jsonDecode(response.body);
    DataTransaction value = DataTransaction.fromJson(data);

    return ApiReturnValue(value: value);
  }

  static Future<ApiReturnValue<MDetailTransaction>> getDetailTransaction(
      int id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('loginToken');

    Uri urlApi = Uri.parse('$url/api/auth/transaction-master/$id');

    var response = await http.get(urlApi, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Terjadi kesalahan, coba lagi');
    }

    var data = jsonDecode(response.body);
    MDetailTransaction value = MDetailTransaction.fromJson(data);

    return ApiReturnValue(value: value);
  }

  static Future<ApiReturnValue<String>> deleteProductTransaction(int id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('loginToken');

    Uri urlApi = Uri.parse('$url/api/auth/transaction/$id');

    var response = await http.delete(urlApi, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    log(urlApi.toString());
    log(response.body);

    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Terjadi kesalahan, coba lagi');
    }

    return ApiReturnValue(value: 'Berhasil');
  }

  static Future<ApiReturnValue<String>> deleteTransaction(int id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('loginToken');

    Uri urlApi = Uri.parse('$url/api/auth/transaction-master/delete/$id');

    var response = await http.get(
      urlApi,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    log(urlApi.toString());
    log(response.body);

    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Terjadi kesalahan, coba lagi');
    }

    return ApiReturnValue(value: 'Berhasil');
  }

  static Future<ApiReturnValue<String>> doneTransaction(
      {int id, String bayar, String kembalian}) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('loginToken');

    Uri urlApi = Uri.parse('$url/api/auth/transaction-master/done/$id');

    var response = await http.post(urlApi, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'bayar': bayar,
      'kembalian': kembalian,
    });

    log(urlApi.toString());
    log(response.body);

    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Terjadi kesalahan, coba lagi');
    }

    return ApiReturnValue(value: 'Berhasil');
  }

  static Future<ApiReturnValue<Report>> getReport() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('loginToken');

    Uri urlApi = Uri.parse('$url/api/auth/report');

    var response = await http.get(urlApi, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Terjadi kesalahan, coba lagi');
    }

    var data = jsonDecode(response.body);
    Report value = Report.fromJson(data);

    return ApiReturnValue(value: value);
  }

  static Future<ApiReturnValue<Report>> filterReport(
      {DateTime from, DateTime until}) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('loginToken');

    Uri urlApi = Uri.parse('$url/api/auth/report?from=$from&to=$until');

    var response = await http.get(urlApi, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    log(urlApi.toString());
    log(response.body);
    log(response.statusCode.toString());

    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Terjadi kesalahan, coba lagi');
    }

    var data = jsonDecode(response.body);
    Report value = Report.fromJson(data);

    return ApiReturnValue(value: value);
  }

  static Future<ApiReturnValue<int>> sendInvoice(
      {String id, String email}) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('loginToken');

    Uri urlApi =
        Uri.parse('$url/api/auth/transaction/send-email/$id?email=$email');

    var response = await http.get(urlApi, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    log(urlApi.toString());
    log(response.body);
    log(response.statusCode.toString());

    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Terjadi kesalahan, coba lagi');
    }

    // var data = jsonDecode(response.body);

    return ApiReturnValue(statusCode: response.statusCode);
  }
}
