// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class ApiService {
//
//   static List<Map<String, dynamic>> responseData = [];
//
//   static Future<void> submitData(List<Map<String, dynamic>> items) async {
//     final apiUrl = 'https://apip.trifrnd.com/Fruits/inv.php?apicall=addinv';
//
//     for (var item in items) {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//         body: {
//           'inv_id': '13',
//           'inv_date': getCurrentDate(), // Set the inv_date with the current date
//           'item_name': item['item_name'] ?? '',
//           'item_price': item['item_price'].toString(),
//           'qty': item['quantity'].toString(),
//           'item_amt': calculateTotalForItem(item['item_name'], item['quantity']).toString(),
//           'bill_amt': calculateGrandTotal(items).toString(),
//         }..removeWhere((key, value) => value == null),
//       );
//
//       print('API Response: ${response.statusCode}');
//       print('API Body : ${response.body}');
//       print('Invoice No: ${generateRandomInvId()}');
//
//       if (response.statusCode == 200 && response.body == "Invoice Added Successfully.") {
//         print('Item ${item['item_name']} added to Cart.');
//       } else {
//         print(' ${response.body}');
//         print('Your Order has been Placed for Total  ${calculateGrandTotal(items).toString()}');
//       }
//     }
//   }
//
//   static double calculateGrandTotal(List<Map<String, dynamic>> items) {
//     double grandTotal = 0.0;
//     for (var item in items) {
//       grandTotal += calculateTotalForItem(item['item_name'], item['quantity']);
//     }
//     return grandTotal;
//   }
//
//   static double calculateTotalForItem(String itemId, int quantity) {
//     var matchingItem = responseData.firstWhere(
//           (item) => item['item_name'] == itemId,
//       orElse: () => {'item_price': '0.0'},
//     );
//     double price = double.parse(matchingItem['item_price']);
//     return price * quantity;
//   }
//
//   static String generateRandomInvId() {
//     return DateTime.now().millisecondsSinceEpoch.toString();
//   }
//
//   static String getCurrentDate() {
//     DateTime currentDate = DateTime.now();
//     String formattedDate = "${currentDate.year}-${currentDate.month}-${currentDate.day}";
//     return formattedDate;
//   }
// }
