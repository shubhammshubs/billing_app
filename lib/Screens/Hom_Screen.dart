import 'dart:convert';
import 'package:billing_app/API/Popup_Item_List_API.dart';
import 'package:billing_app/Screens/Login_Screen.dart';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NavBar.dart';
import 'TableDataDisplayPage.dart';

class HomeScreen extends StatefulWidget {
  final String mobileNumber;

  const HomeScreen({
    Key? key,
    required this.mobileNumber,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> responseData = [];
  Map<String, int> itemQuantities = {};
  String selectedItemId = "";
  int selectedQuantity = 1;
  String submittedInvoiceId = ""; // Add this line
  int _serialNumber = 1; // Add this line
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;


  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _loading = false;

  bool _isMounted = false; // Add this line

  @override
  void initState() {
    super.initState();
    _isMounted = true; // Add this line
    _handleBluetoothPermission();

    fetchData();
  }
  Future<void> _handleBluetoothPermission() async {
    var bluetoothPermissionStatus = await Permission.bluetooth.request();
    var bluetoothScanPermissionStatus =
    await Permission.bluetoothScan.request();

    if (bluetoothPermissionStatus.isGranted &&
        bluetoothScanPermissionStatus.isGranted) {
      print("Bluetooth Permission Granted");
      await _checkBluetoothStatus();
    } else {
      print("Bluetooth Permission Failed");
    }
  }

  Future<void> _checkBluetoothStatus() async {
    bool isBluetoothOn =
    await BluetoothEnable.enableBluetooth.then((result) async {
      print("Bluetooth IS On Stage one");
      await _connectToBluetoothPrinter();
      return result == "true";
    });

    if (isBluetoothOn) {
      print("Bluetooth IS On");
      await _connectToBluetoothPrinter();
    } else {
      print("Bluetooth IS Off");
    }
  }

  Future<void> _connectToBluetoothPrinter() async {
    try {
      setState(() {
        _loading = true;
      });

      String printerName = "BlueTooth Printer";
      String printerAddress = "DC:0D:30:CA:34:E6";

      BluetoothDevice device = BluetoothDevice();
      device.name = printerName;
      device.address = printerAddress;

      print('Selected Bluetooth Device: ${device.name ?? 'Unknown'}');

      if (await bluetoothPrint.isConnected == true) {
        print('Already connected to ${device.name}');
      } else {
        await bluetoothPrint.connect(device);

        if (bluetoothPrint.state == BluetoothPrint.CONNECTED) {
          print('Connected to ${device.name} successfully.');
        } else {
          print('Connection failed. State: ${bluetoothPrint.state}');
          return;
        }
      }

      print('Bluetooth connection successful. You can start printing or perform other tasks.');
    } catch (e, stackTrace) {
      print('Bluetooth connection error: $e');
      print('Stack trace: $stackTrace');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
  @override
  void dispose() {
    _isMounted = false; // Add this line
    super.dispose();
  }
  //  To display the items in a dropdownlist from api.
  Future<void> fetchData() async {
    String apiUrl = "https://apip.trifrnd.com/fruits/inv.php?apicall=items";

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "mobile": widget.mobileNumber,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        responseData = List<Map<String, dynamic>>.from(json.decode(response.body));
        for (var item in responseData) {
          itemQuantities[item['item_name']] = 1;
        }
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
  //  Increase the quantity of the items
  void incrementQuantity() {
    setState(() {
      selectedQuantity++;
    });
  }
  //  Decrease the quantity of the items
  void decrementQuantity() {
    if (selectedQuantity > 1) {
      setState(() {
        selectedQuantity--;
      });
    }
  }
  //
  void addItemToTable() {
    if (selectedItemId.isNotEmpty) {
      setState(() {
        _items.add({
          'serial_number': _serialNumber,
          'item_name': selectedItemId,
          'item_price': responseData
              .firstWhere((item) => item['item_name'] == selectedItemId)['item_price'],
          'quantity': selectedQuantity,
        });
        selectedItemId = "";
        selectedQuantity = 1;
        _serialNumber++; // Increment serial number for the next row
      });
    }
  }
  // To remove the list form the table
  void removeItem(Map<String, dynamic> item) {
    setState(() {
      _items.remove(item);
    });
  }
  // TO calculate the total price of items
  double calculateTotalForItem(String itemId, int quantity) {
    var matchingItem = responseData.firstWhere(
          (item) => item['item_name'] == itemId,
      orElse: () => {'item_price': '0.0'}, // Set a default value for 'item_price'
    );
    double price = double.parse(matchingItem['item_price']); // Convert to double
    return price * quantity;
  }

  // TO calculate the final total price of all items
  double calculateGrandTotal() {
    double grandTotal = 0.0;
    for (var item in _items) {
      grandTotal += calculateTotalForItem(item['item_name'], item['quantity']);
    }
    return grandTotal;
  }

  // TO pass the currente date to api .
  String getCurrentDate() {
    // Get the current date without the time
    DateTime currentDate = DateTime.now();
    String formattedDate = "${currentDate.year}-${currentDate.month}-${currentDate.day}";
    return formattedDate;
  }

  Future<void> submitData() async {
    try {
      setState(() {
        _isLoading = true; // Set loading to true when submitting data
      });

      final latestInvoiceId = await fetchLatestInvoiceId();
      print('Latest Invoice ID: $latestInvoiceId');

      final apiUrl = 'https://apip.trifrnd.com/Fruits/inv.php?apicall=addinv';

      for (var item in _items) {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'inv_id': latestInvoiceId,
            'inv_date': getCurrentDate(),
            'item_name': item['item_name'] ?? '',
            'item_price': item['item_price'].toString(),
            'qty': item['quantity'].toString(),
            'item_amt': calculateTotalForItem(item['item_name'], item['quantity']).toString(),
            'bill_amt': calculateGrandTotal().toString(),
          }..removeWhere((key, value) => value == null),
        );

        print('API Response: ${response.statusCode}');
        print('API Body : ${response.body}');

        if (response.body == "Invoice Added Successfully.") {
          final snackBar = SnackBar(
            content: Text(
              'Item ${item['item_name']} added to Cart.',
              textAlign: TextAlign.center,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        } else {
          print(' ${response.body}');

        }
      }

      // Clear the _items list after successful submission
      setState(() {
        _items.clear();
      });

      submittedInvoiceId = latestInvoiceId; // Store the submitted invoice ID
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DataDisplayPage(
              latestInvoiceId: submittedInvoiceId,
            mobileNumber: widget.mobileNumber,
          ),
        ),
      );
      // Reload the data after successful submission
      fetchData();
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false; // Set loading to false when submission is complete
      });
    }
  }

  // This code is for getting the lettest InvoiceId fro the api to pass into addinv
  Future<String> fetchLatestInvoiceId() async {
    final apiUrl = 'https://apip.trifrnd.com/Fruits/inv.php?apicall=readid';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );

    if (response.statusCode == 200) {
      return response.body.trim();
    } else {
      throw Exception('Failed to fetch latest invoice ID');
    }
  }






  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    const double defaultPadding = 16.0;
    const double defaultMargin = 16.0;

    double responsivePadding = screenWidth * 0.05;
    double responsiveMargin = screenWidth * 0.05;
    double responsiveFontSize = screenWidth * 0.04;
    double containerWidth = screenWidth * 0.8;
    double containerHeight = screenHeight * 0.3;

    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        drawer: NavBar(mobileNumber: widget.mobileNumber),
        appBar: AppBar(
          title: Text("Billing App"),
          centerTitle: true,
          backgroundColor: Colors.orange,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
              setState(() {});
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await fetchData();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(responsivePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: screenHeight * 0.07,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButton<String>(
                          value: selectedItemId.isNotEmpty ? selectedItemId : null,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedItemId = newValue!;
                            });
                          },
                          items: responseData
                              .map<DropdownMenuItem<String>>(
                                (item) => DropdownMenuItem<String>(
                              value: item['item_name'],
                              child: Text(item['item_name']),
                            ),
                          )
                              .toList(),
                          hint: const Text('Select Item'),
                        ),
                      ),
                      SizedBox(width: responsivePadding),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: decrementQuantity,
                              iconSize: responsiveFontSize,
                            ),
                            Text('$selectedQuantity', style: TextStyle(fontSize: responsiveFontSize)),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: incrementQuantity,
                              iconSize: responsiveFontSize,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsivePadding),
                  Container(
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Total: ${calculateTotalForItem(selectedItemId, selectedQuantity).toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsiveFontSize),
                      ),
                    ),
                  ),
                  SizedBox(height: responsivePadding),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: addItemToTable,
                        child: Text('Add Item', style: TextStyle(fontSize: responsiveFontSize)),
                      ),
                    ],
                  ),

                  SizedBox(height: responsivePadding),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      defaultColumnWidth: IntrinsicColumnWidth(),
                      border: TableBorder.all(),
                      children: [
                        TableRow(
                          children: [
                            TableCell(child: Text('Sr.\nNo.', style: TextStyle(fontSize: responsiveFontSize))),
                            TableCell(child: Center(child: Text('Item\nName', style: TextStyle(fontSize: responsiveFontSize)))),
                            TableCell(child: Center(child: Text('Price', style: TextStyle(fontSize: responsiveFontSize)))),
                            TableCell(child: Center(child: Text('Quantity', style: TextStyle(fontSize: responsiveFontSize)))),
                            TableCell(child: Center(child: Text('Total', style: TextStyle(fontSize: responsiveFontSize)))),
                            TableCell(child: Center(child: Text('Remove', style: TextStyle(fontSize: responsiveFontSize)))),
                          ],
                        ),
                        for (var item in _items)
                          TableRow(
                            children: [
                              TableCell(child: Center(child: Text(item['serial_number'].toString(), style: TextStyle(fontSize: responsiveFontSize)))),
                              TableCell(child: Text(' ${item['item_name']} ', style: TextStyle(fontSize: responsiveFontSize))),
                              TableCell(child: Text(' ${item['item_price']} ', style: TextStyle(fontSize: responsiveFontSize))),
                              TableCell(child: Center(child: Text(' ${item['quantity']} ', style: TextStyle(fontSize: responsiveFontSize)))),
                              TableCell(
                                child: Center(
                                  child: Text(
                                    ' ${calculateTotalForItem(item['item_name'], item['quantity']).toStringAsFixed(2)} ',
                                    style: TextStyle(fontSize: responsiveFontSize),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: IconButton(
                                  icon: Icon(Icons.remove_circle_outline_rounded),
                                  color: Colors.red,
                                  onPressed: () {
                                    removeItem(item);
                                  },
                                ),
                              ),
                            ],
                          ),
                        TableRow(
                          children: [
                            TableCell(child: Center(child: Text(''))),
                            TableCell(child: Center(child: Text(''))),
                            TableCell(child: Center(child: Text(''))),
                            TableCell(
                              child: Center(
                                child: Text(
                                  'Total:',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsiveFontSize),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Text(
                                  '${calculateGrandTotal().toStringAsFixed(2)}  ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsiveFontSize),
                                ),
                              ),
                            ),
                            TableCell(child: Center(child: Text(''))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: responsivePadding),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                      await submitData();
                    },
                    style: ButtonStyle(
                      // backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Submit', style: TextStyle(fontSize: responsiveFontSize)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




