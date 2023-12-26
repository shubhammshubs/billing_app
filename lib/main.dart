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
// import 'package:bluetooth_print/bluetooth_print.dart';
// import 'package:bluetooth_print/bluetooth_print_model.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class PrintPage extends StatefulWidget {
//   final List<Map<String,dynamic>> data;
//   const PrintPage({super.key,
//     required this.data});
//
//   @override
//   State<PrintPage> createState() => _PrintPageState();
// }
//
// class _PrintPageState extends State<PrintPage> {
//   BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
//   List<BluetoothDevice> _devices = [];
//   String _deviceMsg = "";
//   // final f = NumberFormat("\$###,###.00","en_us");
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {initPrinter();});
//   }
//
//   Future<void> initPrinter() async {
//     bluetoothPrint.startScan(timeout: Duration(seconds: 2));
//
//     if(!mounted) return;
//     bluetoothPrint.scanResults.listen((val) {
//       if(!mounted) return;
//       setState(() {
//         _devices = val;
//       });
//       if(_devices.isEmpty)
//         setState(() {
//           _deviceMsg = "No Devices Found";
//         });
//     });
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Select Printer "),
//         backgroundColor: Colors.red,
//       ),
//       body: _devices.isEmpty ?
//       Center(child: Text(_deviceMsg ?? ''),)
//           :
//           ListView.builder(
//               itemCount: _devices.length,
//               itemBuilder: (c,i) {
//                 return ListTile(
//                   leading: Icon(Icons.print),
//                   title: Text(_devices[i].name ?? ''),
//                   subtitle: Text(_devices[i].address ?? ''),
//                   onTap: () {
//
//                   },
//                 );
//               })
//     );
//   }
// }
