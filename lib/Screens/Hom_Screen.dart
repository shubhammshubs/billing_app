import 'dart:convert';
import 'package:billing_app/API/Popup_Item_List_API.dart';
import 'package:billing_app/Screens/Login_Screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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


  @override
  void initState() {
    super.initState();
    fetchData();
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
          'item_name': selectedItemId,
          'item_price': responseData
              .firstWhere((item) => item['item_name'] == selectedItemId)['item_price'],
          'quantity': selectedQuantity,
        });
        selectedItemId = "";
        selectedQuantity = 1;
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

  // code to pass the information to the api .
  Future<void> submitData() async {
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


      if (response.statusCode == 200 && response.body == "Invoice Added Successfully.") {
        final snackBar = SnackBar(
          content: Text(
            'Item ${item['item_name']} added to Cart.',
            textAlign: TextAlign.center,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // Reload the data after successful submission
        fetchData();
      } else {
        print(' ${response.body}');
      }
    }
    submittedInvoiceId = latestInvoiceId; // Store the submitted invoice ID

    // THe naviator to refresh the page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(mobileNumber: widget.mobileNumber),
      ),
    );
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



  // code to call the Display Table Popup window to display the records
  Future<void> displayTableData() async {
    try {
      final latestInvoiceId = submittedInvoiceId;

      await TableDataDisplay.displayTableData(context, latestInvoiceId);

      // Handle logic after the table data is displayed here
      print("Invoice Displayed Successfully");

    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Billing App"),
        centerTitle: true,
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false, // This line removes the back button

        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: ()  async {
              SharedPreferences preferences = await SharedPreferences.getInstance();
              preferences.clear();
              // Add your logout logic here
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                  LoginScreen(),
                  ));

            },
          ),
        ],
      ),
      body:
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  // Dropdown list to dispaly all the items from the items api
                  Container(
                    // width: 100, // Set your desired width
                    height: 50, // Set your desired height
                    decoration: BoxDecoration(
                      border: Border.all(), // Add border styling as needed
                      borderRadius: BorderRadius.circular(8.0), // Optional: Add border radius for rounded corners
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
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(), // Add border styling as needed
                      borderRadius: BorderRadius.circular(8.0), // Optional: Add border radius for rounded corners
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: decrementQuantity,
                        ),
                        Text('$selectedQuantity'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: incrementQuantity,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    // width: 100, // Set your desired width
                    height: 50, // Set your desired height
                    decoration: BoxDecoration(
                      border: Border.all(), // Add border styling as needed
                      borderRadius: BorderRadius.circular(8.0), // Optional: Add border radius for rounded corners
                    ),
                    child: Center(
                      child: Text(
                        ' Total:  ${calculateTotalForItem(selectedItemId, selectedQuantity).toStringAsFixed(2)} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: addItemToTable,
                    child: const Text('Add Item'),
                  ),
                ],
              ),
        
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Table(
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  border: TableBorder.all(),
                  children: [
                    const TableRow(
                      children: [
                        TableCell(child: Center(child: Text('Item Name'))),
                        TableCell(child: Center(child: Text('Price'))),
                        TableCell(child: Center(child: Text('Quantity'))),
                        TableCell(child: Center(child: Text('Total'))),
                        TableCell(child: Center(child: Text('Remove'))),
                      ],
                    ),
                    for (var item in _items)
                      TableRow(
                        children: [
                          TableCell(child: Text('  ${item['item_name']}  ')),
                          TableCell(child: Text('  ${item['item_price']}  ',)),
                          TableCell(child: Center(child: Text('  ${item['quantity']}  '))),
                          TableCell(
                            child: Center(
                              child: Text(
                                '  ${calculateTotalForItem(item['item_name'], item['quantity']).toStringAsFixed(2)}  ',
                              ),
                            ),
                          ),
                          TableCell(
                            child: IconButton(
                              icon: const Icon(Icons.remove_circle_outline_rounded),
                              color: Colors.red,
                              onPressed: () {
                                // Remove the item from the list when the remove icon is tapped
                                removeItem(item);
                              },
                            ),
                          ),
                        ],
                      ),
        
                    TableRow(
        
                      children: [
                        const TableCell(child: SizedBox.shrink()),
                        const TableCell(child: SizedBox.shrink()),
                        const TableCell(
                          child: Center(
                            child: Text(
                              ' Total:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Text(
                              '${calculateGrandTotal().toStringAsFixed(2)}  ',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const TableCell(child: SizedBox.shrink()),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // TODO: Demo
              ElevatedButton(
                onPressed: () async {
                  await submitData();
                  displayTableData();
                },
                style: ButtonStyle(
                  // backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                ),
                child: const Text('Submit',),

              ),
            ],
          ),
        ),
      ),
    );
  }
}

