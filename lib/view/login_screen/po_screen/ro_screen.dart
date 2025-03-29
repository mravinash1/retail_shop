import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:po/controller/item_controller.dart';

class PlaceOrderScreen extends StatelessWidget {
  final ItemController controller = Get.put(ItemController());
  final TextEditingController searchController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text("Purchase order")),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) => controller.searchItem(value),
                decoration: InputDecoration(
                  labelText: "Search Item", 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  )),
              ),
            ),
          ),

          // ✅ Search Results
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final item = controller.searchResults[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text("Barcode: ${item.barcode} | Rate: ${item.rate}"),
                    trailing: TextButton(
                   //   icon: Icon(Icons.add_shopping_cart),
                   child: Text('Req Qty',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                      onPressed: () {
                        quantityController.clear();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Enter Quantity"),
                            content: TextField(
                              controller: quantityController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: "Quantity"),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  controller.addItem(item, quantityController.text);
                                  Navigator.pop(context);
                                },
                                child: Text("Add"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),

          // ✅ Selected Items & Order Button
          Obx(() => controller.selectedItems.isNotEmpty
              ? Column(
                  children: [
                    Text("Selected Items:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ...controller.selectedItems.map((item) => ListTile(
                          title: Text(item['rawname']),
                          subtitle: Text("Qty: ${item['qty']} | Rate: ${item['rate']}"),
                        )),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => controller.createOrder(),
                      child: Text("Place Order"),
                    ),
                    SizedBox(height: 19,),
                  ],
                )
              : SizedBox.shrink()),
        ],
      ),
    );
  }
}
