import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:po/view/login_screen/po_screen/po_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/endpoint.dart';
import '../models/login_shop_models.dart';
import '../utils/api_service_class.dart';

  class LoginController extends GetxController {
  int userId = 0;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Loginshopmallmodels? loginShopModel;
  List<Loginshopmallmodels> loginshop = [];
  bool isLoading = false;

    Future loginData() async {
    isLoading = true;
    try {
      var response = await HttpService().get(
          "${AppConstants.loginshope}${emailController.text}/${passwordController.text}");
      print('>>>>>>>>>>>>>>>>>>>>>response $response');

      debugPrint("response  $response");
      if (response != null) {
        loginshop = List<Loginshopmallmodels>.from(
            response.map((x) => Loginshopmallmodels.fromJson(x)));
        if (loginshop.isNotEmpty) {
          userId = loginshop[0].id!;

          // Save user ID as an integer in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('shopId', userId); // Use setInt instead of setString
         

          Get.to(() => PurchaseOrderView());
          update();

          Get.snackbar(
            'User Found',
            'login successful',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.black,
            icon: Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.black,
            ),
            borderRadius: 15,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            duration: Duration(seconds: 2),
            forwardAnimationCurve: Curves.easeOutBack,
          );
        } else {
          Get.snackbar(
            'faild',
            'Enter valid enter and password',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.black,
            icon: Icon(Icons.error_outline, color: Colors.black),
            borderRadius: 15,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            duration: Duration(seconds: 4),
            forwardAnimationCurve: Curves.easeOutBack,
          );
        }

        debugPrint("data  $loginshop");
        isLoading = false;
        update();
      }
    } catch (e) {
      isLoading = false;

      update();
      debugPrint("catch  $e");
    } finally {
      isLoading = false;
      update();
    }
  }


// Function to retrieve the userId from SharedPreferences
Future<int?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userId'); // Use getInt instead of getString
}

@override
void onInit() {
  super.onInit();

  // Retrieve userId when the controller is initialized
  getUserId().then((value) {
    if (value != null) {
      userId = value; // No need for type conversion now
      update();
    }
  });
}

}