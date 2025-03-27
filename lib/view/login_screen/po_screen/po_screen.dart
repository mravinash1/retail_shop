// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:po/controller/po_controller.dart';
import 'package:po/view/login_screen/po_screen/item_details.dart';

  class PurchaseOrderView extends StatelessWidget {
  final controller = Get.put(PurchaseOrderController());
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,

          leading:
          InkWell(
            onTap: () {   
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: Text(
                    'Exit App',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Text(
                    'Are you sure you want to exit?', 
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(), // Dismiss dialog
                      child: Text(
                        'No',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.back(result: true), // Exit the app
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ).then((exit) {
                if (exit == true) {
                  Get.back(); // Exit the screen
                }
              });
            },
            child: Icon(Icons.exit_to_app_outlined, color: Colors.white),
          ),
          title: Column(
            children: [
              Text("Requisition Order", style: TextStyle(color: Colors.white)),
              SizedBox(height: 10),

              // Text(
              //   DateFormat('dd-MM-yyyy').format(DateTime.now()),
              //   style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              // ),

              Obx(() => Text(
                    controller.selectedDateRange.value.isEmpty
                        ? DateFormat('dd-MM-yyyy').format(DateTime.now())
                        : controller.selectedDateRange.value,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.calendar_month, color: Colors.white),
              onPressed: () async {
                DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          surface: Colors.black,
                          onSurface: Colors.white,
                        ),
                        dialogBackgroundColor: Colors.grey[900],
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  controller.startDate =
                      DateFormat('yyyy-MM-dd').format(picked.start);
                  controller.endDate =
                      DateFormat('yyyy-MM-dd').format(picked.end);
                  controller.update();
                  controller.fetchPurchaseOrders(
                      controller.startDate, controller.endDate);
                }
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async{
          //  await controller.fetchPurchaseOrders(controller.startDate, controller.endDate);
            await controller.fetchPurchaseOrders(controller.startDate, controller.endDate);
            
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) => controller.filterOrders(value),
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Search Item",
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (controller.filteredOrders.isEmpty) {
                      return Center(
                        child: Text(
                          "No Purchase Orders Available",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: controller.filteredOrders.length,
                      itemBuilder: (context, index) {
                        var item = controller.filteredOrders[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.grey[900],
                          margin: EdgeInsets.all(5),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                  'Item :',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  item.rawname,
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                )
                                  ],
                                ),
                                  

                                  Row(
                                    children: [
                                       Text('Pkg : ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
                                   Text('10',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                    ],
                                  )

                               
                                
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Ord Qty: ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      item.otherQty % 1 == 0
                                          ? item.otherQty.toStringAsFixed(0)
                                          : item.otherQty.toStringAsFixed(2),
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    SizedBox(width: 4), // Reduce the gap
                                    Text(
                                      item.unitname,
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'RecQty: ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      item.reqQty % 1 == 0
                                          ? item.reqQty.toStringAsFixed(0)
                                          : item.reqQty.toStringAsFixed(2),
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(width: 4), // Reduce the gap
                                    Text(
                                      item.unitname,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: Icon(Icons.arrow_forward_ios_rounded),
                            ),
                            onTap: () {
                              var item = controller.filteredOrders[index];
                              Get.to(() => ItemDetailView(item: item));
                            },
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


