import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:po/models/po_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

  class PurchaseOrderController extends GetxController {
  var purchaseOrders = <PurchaseModelClass>[].obs;
  var filteredOrders = <PurchaseModelClass>[].obs;
  var isLoading = false.obs;
  var selectedDateRange = ''.obs; // New variable for selected date range
  String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String startDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 7)));
    

  @override
  void onInit() {
    super.onInit();
    
    fetchPurchaseOrders(startDate, endDate);
  }


    void updateSelectedDateRange(String startDate, String endDate) {
    selectedDateRange.value = '$startDate to $endDate';
     }

  /// Fetch Purchase Orders from the API
  Future<void> fetchPurchaseOrders(String startDate, String endDate) async {
    try {
      isLoading.value = true;
       updateSelectedDateRange(startDate, endDate); // Update date range

// Save user ID as an integer in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var shopId = await prefs.getInt('shopId');

      final response = await http.get(
        Uri.parse('https://api.retail.billhost.co.in/purchaseorderReport/$shopId/$startDate/$endDate/0'),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        purchaseOrders.value = jsonResponse
            .map<PurchaseModelClass>((item) => PurchaseModelClass.fromJson(item))
            .toList();
        filteredOrders.value = purchaseOrders;

        print("Data fetched successfully");
      } else {
        print('Failed: Invalid date range');
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

void updateOrderQty(int deptcode, int rawcode, int shopid, int qty) async {
  try {
    var url = Uri.parse('https://api.retail.billhost.co.in/POunitupdate');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "deptcode": deptcode,
        "rawcode": rawcode,
        "qty": qty,
        "shopid": shopid,
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        'Quantity updated successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Refresh the list after updating
      //String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    //String startDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 7)));

    fetchPurchaseOrders(startDate, endDate);
    } else {
      Get.snackbar(
        'Error',
        'Failed to update quantity!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error: ${response.body}');
    }
  } catch (e) {
    print("Exception: $e");
    Get.snackbar(
      'Error',
      'Something went wrong!',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
 


  /// Filter Purchase Orders based on search query
  void filterOrders(String query) {
    if (query.isEmpty) {
      filteredOrders.value = purchaseOrders;
    } else {
      filteredOrders.value = purchaseOrders
          .where((order) => order.rawname.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
