// import 'package:flutter/material.dart';
//
// import 'Screens/Login_Screen.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Grocery App',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
//       home: LoginScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/Hom_Screen.dart';
import 'Screens/Login_Screen.dart';
// import 'Screens/Home_Screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      // Check login status and get mobile number
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Still waiting for the check to complete
          return CircularProgressIndicator(); // or some loading indicator
        } else {
          if (snapshot.data!['isLoggedIn']) {
            // User is logged in, navigate to HomeScreen
            return MaterialApp(
              title: 'Grocery App',
              theme: ThemeData(
                primarySwatch: Colors.green,
              ),
              home: HomeScreen(
                mobileNumber: snapshot.data!['mobileNumber'],
              ),
            );
          } else {
            // User is not logged in, navigate to LoginScreen
            return MaterialApp(
              title: 'Grocery App',
              theme: ThemeData(
                primarySwatch: Colors.green,
              ),
              home: LoginScreen(),
            );
          }
        }
      },
    );
  }

  // Function to check login status and get mobile number
  Future<Map<String, dynamic>> checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isLoggedIn = sharedPreferences.getBool('isLoggedIn') ?? false;
    String? mobileNumber = sharedPreferences.getString('mobile');

    return {
      'isLoggedIn': isLoggedIn,
      'mobileNumber': mobileNumber,
    };
  }
}
// This code it Home Screen Backup

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
//
// import 'Login_Screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   final String mobileNumber;
//
//   const HomeScreen({
//     Key? key,
//     required this.mobileNumber,
//   }) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   List<Map<String, dynamic>> _items = [];
//   List<Map<String, dynamic>> responseData = []; // Declare it here
//   int selectedQuantity = 1;
//
//   @override
//   void initState() {
//     super.initState();
//     // Fetch data when the widget is initialized
//     fetchData();
//   }
//
//   Future<void> fetchData() async {
//     String apiUrl = "https://apip.trifrnd.com/fruits/inv.php?apicall=items";
//
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       body: {
//         "mobile": widget.mobileNumber,
//       },
//     );
//
//     if (response.statusCode == 200) {
//       setState(() {
//         responseData = List<Map<String, dynamic>>.from(json.decode(response.body));
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   void incrementQuantity() {
//     setState(() {
//       selectedQuantity++;
//       // You can add any additional logic when the quantity increases
//     });
//   }
//
//   void decrementQuantity() {
//     if (selectedQuantity > 1) {
//       setState(() {
//         selectedQuantity--;
//         // You can add any additional logic when the quantity decreases
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('API Demo'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Mobile Number: ${widget.mobileNumber}'),
//               // SizedBox(height: 20),
//               Text('Response Data:'),
//               // Create a Card for each item
//               for (var item in responseData)
//                 Card(
//                   child: ListTile(
//                     title: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('${item['item_name']}'),
//                         Text('Price: ${item['item_price']}'),
//                         // Add plus and minus buttons
//                         Row(
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.remove),
//                               onPressed: () {
//                                 decrementQuantity();
//                               },
//                             ),
//                             Text('$selectedQuantity'),
//                             IconButton(
//                               icon: Icon(Icons.add),
//                               onPressed: () {
//                                 incrementQuantity();
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }






// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
//
// class HomeScreen extends StatefulWidget {
//   final String mobileNumber;
//
//   const HomeScreen({
//     Key? key,
//     required this.mobileNumber,
//   }) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   List<Map<String, dynamic>> _items = [];
//   List<Map<String, dynamic>> responseData = [];
//   Map<String, int> itemQuantities = {};
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   Future<void> fetchData() async {
//     String apiUrl = "https://apip.trifrnd.com/fruits/inv.php?apicall=items";
//
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       body: {
//         "mobile": widget.mobileNumber,
//       },
//     );
//
//     if (response.statusCode == 200) {
//       setState(() {
//         responseData = List<Map<String, dynamic>>.from(json.decode(response.body));
//         // Initialize itemQuantities with the initial quantity (1 for each item)
//         for (var item in responseData) {
//           itemQuantities[item['item_name']] = 1;
//         }
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   void incrementQuantity(String itemName) {
//     setState(() {
//       itemQuantities[itemName] = (itemQuantities[itemName] ?? 0) + 1;
//     });
//   }
//
//   void decrementQuantity(String itemName) {
//     if (itemQuantities[itemName] != null && itemQuantities[itemName]! > 1) {
//       setState(() {
//         itemQuantities[itemName] = itemQuantities[itemName]! - 1;
//       });
//     }
//   }
//
//   double calculateTotal(Map<String, dynamic> item, int quantity) {
//     double price = double.parse(item['item_price']);
//     return price * quantity;
//   }
//
//   double calculateGrandTotal() {
//     double grandTotal = 0.0;
//     for (var item in responseData) {
//       grandTotal += calculateTotal(item, itemQuantities[item['item_name']] ?? 0);
//     }
//     return grandTotal;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('API Demo'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Table(
//             defaultColumnWidth: IntrinsicColumnWidth(),
//             border: TableBorder.all(),
//             children: [
//               // Table header
//               TableRow(
//                 children: [
//                   TableCell(child: Center(child: Text('Item Name'))),
//                   TableCell(child: Center(child: Text('Price'))),
//                   TableCell(child: Center(child: Text('Quantity'))),
//                   TableCell(child: Center(child: Text('Total'))),
//                 ],
//               ),
//               // Table body with item details
//               for (var item in responseData)
//                 TableRow(
//                   children: [
//                     TableCell(child: Text('  ${item['item_name']}  ')),
//                     TableCell(child: Text('  ${item['item_price']}  ')),
//                     TableCell(
//                       child: Center(
//                         child: Container(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               IconButton(
//                                 icon: Icon(Icons.remove),
//                                 onPressed: () {
//                                   decrementQuantity(item['item_name']);
//                                 },
//                               ),
//                               Text('${itemQuantities[item['item_name']] ?? 0}'),
//                               IconButton(
//                                 icon: Icon(Icons.add),
//                                 onPressed: () {
//                                   incrementQuantity(item['item_name']);
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     TableCell(
//                       child: Center(
//                         child: Text(
//                           '  \$${calculateTotal(item, itemQuantities[item['item_name']] ?? 0).toStringAsFixed(2)}  ',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               // Additional row for Grand Total
//               TableRow(
//                 children: [
//                   TableCell(child: SizedBox.shrink()), // Empty cell for Item Name
//                   TableCell(child: SizedBox.shrink()), // Empty cell for Price
//                   TableCell(child: SizedBox.shrink()), // Empty cell for Quantity
//                   TableCell(
//                     child: Center(
//                       child: Text(
//                         ' Total: ${calculateGrandTotal().toStringAsFixed(2)}  ',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
