import 'dart:convert';
import 'package:flutter_wisata_renald/core/constants/variables.dart';
import 'package:flutter_wisata_renald/data/models/response/qris_status_response_model.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_wisata_renald/data/models/response/qris_response_model.dart';

// String serverKey = 'Mid-server-CvNx9YqsIJiuIOZeC383IPnA';
String serverKey = 'SB-Mid-server-GUJOPIhHF9b1D1ffzjmtPHnf';

class MidtransRemoteDatasource {
  String generateBasicAuthHeader(String serverKey) {
    final base64Credentials = base64Encode(utf8.encode('$serverKey:'));
    final authHeader = 'Basic $base64Credentials';

    return authHeader;
  }

  Future<QrisResponseModel> generateQRCode(
      String orderId, int grossAmount) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(serverKey),
    };
    final body = jsonEncode({
      "payment_type": "gopay",
      "transaction_details": {
        "order_id": orderId,
        "gross_amount": grossAmount,
      }
    });

    final response = await http.post(
      Uri.parse('${Variables.qrisBaseUrl}/v2/charge'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return QrisResponseModel.fromJson(response.body);
    } else {
      throw Exception('Failed to generate QR Code.');
    }
  }

  Future<QrisStatusResponseModel> checkPaymentStatus(
      String transactionId) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(serverKey),
    };

    final response = await http.get(
      Uri.parse('${Variables.qrisBaseUrl}/v2/$transactionId/status'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return QrisStatusResponseModel.fromJson(response.body);
    } else {
      throw Exception('Failed to check payment status.');
    }
  }
}
