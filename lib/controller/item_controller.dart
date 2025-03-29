import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item_master_model.dart';
import 'package:intl/intl.dart'; 


 class ItemController extends GetxController {
  var items = <Item>[].obs;
  var searchResults = <Item>[].obs;
  var selectedItems = <Map<String, dynamic>>[].obs;
  var searchText = ''.obs;
  var shopId = ''.obs;
  var orders = <Map<String, dynamic>>[].obs; 

  @override
  void onInit() {
    super.onInit();
    fetchShopId();
    fetchItems();
  } 

 

 
 void fetchShopId() async {
  final prefs = await SharedPreferences.getInstance();
  dynamic storedValue = prefs.get('shopId'); // Get value (can be int or String)
  
  // Convert int to String if necessary
  shopId.value = storedValue != null ? storedValue.toString() : '1'; 
}



  void fetchItems() async {
    final prefs = await SharedPreferences.getInstance();
    int? shopId = prefs.getInt('shopId'); // Shared Preferences se shop ID fetch karein
        

    if (shopId == null) {
      print("Shop ID not found in SharedPreferences!");
      return;
    }

    final response = await http
        .get(Uri.parse('https://api.retail.billhost.co.in/$shopId/itemmaster'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      items.value = data.map((item) => Item.fromJson(item)).toList();
    } else {
      print(" API Error: ${response.statusCode}");
    }
  }

    void searchItem(String query) {
    searchText.value = query;
    if (query.isEmpty) {
      searchResults.clear();
    } else {
      searchResults.value = items.where(
        (item) => item.name.toLowerCase().contains(query.toLowerCase())).toList();
          
    }
  }

  Future<void> saveShopId(int shopId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('shopId', shopId);
  }

  //  Add Item to Selected List

  void addItem(Item item, String quantity) {
    selectedItems.add({
      'rawcode': item.id,
      'rawname': item.name,
      'barcode': item.barcode,
      'discperc': 0,
      'unitname': item.unit,
      'qty': int.tryParse(quantity) ?? 1,
      'rate': item.rate,
      'gst': 0,
      'id': '',
      'shopid': shopId.value,
      'totqty': int.tryParse(quantity) ?? 1,
      'vdate': '2025-03-27',
      'totpoamt': item.rate * (int.tryParse(quantity) ?? 1),
      'fromdeptcode': 2,
      'todeptcode': 0
    });
  }


void createOrder() async {
  final prefs = await SharedPreferences.getInstance();
  dynamic storedShopId = prefs.get('shopId'); // Can be int or String
  String shopIdString = storedShopId != null ? storedShopId.toString() : '1'; // Ensure String

  String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  var updatedItems = selectedItems.map((item) {
    return {
      ...item,
      'shopid': shopIdString, // ✅ Ensure shopId is a string
      'vdate': todayDate,
    };
  }).toList();

  final response = await http.post(
    Uri.parse('https://api.retail.billhost.co.in/purchaseorder'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(updatedItems),
  );

  print("Response Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    Get.snackbar("Success", "PO Created Successfully", snackPosition: SnackPosition.BOTTOM);
    selectedItems.clear();
  } else {
    Get.snackbar("Error", "Failed to create order", snackPosition: SnackPosition.BOTTOM);
  }
}

}
