import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:po/controller/po_controller.dart';
import 'package:po/models/po_models.dart';

  class ItemDetailView extends StatelessWidget {
  final PurchaseModelClass item;  // Use your model class

  ItemDetailView({required this.item});

  final TextEditingController qtyController = TextEditingController();
  final TextEditingController pacController = TextEditingController();
  final TextEditingController purController = TextEditingController();
  final TextEditingController remController = TextEditingController();

   final controller = Get.put(PurchaseOrderController());


  @override
  Widget build(BuildContext context) {
    qtyController.text = item.otherQty.toString();

    return Scaffold(

      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios)),
        title: Text("Item Details"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Enter Order Quantity",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
            //  controller: qtyController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Package",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
         SizedBox(height: 16),
           TextField(
            //  controller: qtyController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Purchase Price",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),
           TextField(
            //  controller: qtyController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Remarks",
                labelStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
         
         
           SizedBox(height: 16),

 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

             ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green
              ),
              onPressed: (){
                Get.back();

             }, child: Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),

    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green
      ) ,
  onPressed: () {
    int deptcode = item.fromdeptcode.toInt();
    int rawcode = item.rawcode.toInt();
    int shopid = item.shopid.toInt();
   int qty = double.parse(qtyController.text).toInt();


    controller.updateOrderQty(deptcode, rawcode, shopid, qty );
        Get.back();
  },
  child: Text('Update',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
),

  
          ],
        ),
              
          ],
        ),
      ),
    );
  }
}
