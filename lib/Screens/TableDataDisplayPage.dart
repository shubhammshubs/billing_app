import 'dart:convert';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class DataDisplayPage extends StatefulWidget {
  final String latestInvoiceId;
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  DataDisplayPage({required this.latestInvoiceId});

  @override
  _DataDisplayPageState createState() => _DataDisplayPageState();



}

class _DataDisplayPageState extends State<DataDisplayPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _handleBluetoothPermission();
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

  final String apiUrl = "https://apip.trifrnd.com/Fruits/inv.php?apicall=readinv";

  Future<List<Map<String, dynamic>>> fetchTableData(String latestInvoiceId) async {
    try {
      final apiUrl = 'https://apip.trifrnd.com/Fruits/inv.php?apicall=readinv';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        // body: {'inv_id': "45"},
        body: {'inv_id': "${latestInvoiceId}"},
      );

      if (response.statusCode == 200) {
        dynamic decodedData = json.decode(response.body);

        if (decodedData is List) {
          return List<Map<String, dynamic>>.from(decodedData);
        } else if (decodedData is Map<String, dynamic>) {
          // If the decoded data is a map, wrap it in a list
          return [decodedData];
        } else {
          throw Exception('Unexpected API response format');
        }
      } else {
        print("Invoice ID ${latestInvoiceId}");
        throw Exception('Failed to fetch table data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Invoice ID ${latestInvoiceId}");
      print('Error fetching table data: $e');
      throw Exception('Plesase add the data to the list');
    }
  }

  String _formatDate(String rawDate) {
    DateTime dateTime = DateTime.parse(rawDate);
    String formattedDate = '${dateTime.day}-${dateTime.month}-${dateTime.year}';
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Example'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTableData(widget.latestInvoiceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var tableData = snapshot.data;
            double totalBillAmount = 0;

            // Calculate total bill amount
            for (var item in tableData!) {
              totalBillAmount += double.parse(item['item_amt']);
            }

            return Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 5,),
                    Text(
                      'Invoice ID ${widget.latestInvoiceId}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 100),
                  ],
                ),
                if (tableData!.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(width: 100),
                      Text(
                        'Date: ${_formatDate(tableData.first['inv_date'])}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                Table(

                  border: TableBorder.all(),

                  children: [
                    TableRow(
                      children: [
                        TableCell(child: Center(child: Text('Sr\n No.'))),
                        TableCell(child: Center(child: Text('Item Name'))),
                        TableCell(child: Center(child: Text('Price'))),
                        TableCell(child: Center(child: Text('Quantity'))),
                        TableCell(child: Center(child: Text('Total'))),
                      ],
                    ),
                    for (int index = 0; index < tableData.length; index++)
                      TableRow(
                        children: [
                          TableCell(child: Center(child: Text((index + 1).toString()))),
                          TableCell(child: Text('${tableData[index]['item_name']}')),
                          TableCell(child: Center(child: Text('${tableData[index]['item_price']}'))),
                          TableCell(child: Center(child: Text('${tableData[index]['qty']}'))),
                          TableCell(
                            child: Center(
                              child: Text('${tableData[index]['item_amt']}'),
                            ),
                          ),
                        ],
                      ),
                    TableRow(
                      children: [
                        const TableCell(child: SizedBox.shrink()),
                        const TableCell(child: SizedBox.shrink()),
                        const TableCell(child: SizedBox.shrink()),
                        const TableCell(
                          child: Center(
                            child: Text(
                              'Bill Amount:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Text(
                              '${totalBillAmount.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _printData,
                  child: Text('Print'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
  Future<void> _printData() async {
    try {
      // Assuming you have fetched the table data in the widget's state
      var tableData = await fetchTableData(widget.latestInvoiceId);

      // Connect to Bluetooth printer
      await _connectToBluetoothPrinter();

      // Replace the following lines with your actual Bluetooth printer details
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

      Map<String, dynamic> config = Map();
      List<LineText> list = [];
      // list.add(LineText(
      //   type: LineText.TYPE_TEXT,
      //   content: "----------------------------------------", // Empty content for space
      //   width: 2, // Adjust this value to control the amount of space on the left
      //   linefeed: 1,
      // ));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'Grocery Bill',
          weight: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1));
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: "", // Empty content for space
        width: 2, // Adjust this value to control the amount of space on the left
        linefeed: 1,
      ));

      for (var index = 0; index < tableData.length; index++) {
        var item = tableData[index];
        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: '${index + 1}. ${item['item_name']}',
            width: 0,
            align: LineText.ALIGN_LEFT,
            linefeed: 1));


        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "${item['item_price']} X ${item['qty']} =  ${item['item_price']}", // Concatenate both pieces of content
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
        ));

// Add an indented LineText for space on the left
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "", // Empty content for space
          width: 2, // Adjust this value to control the amount of space on the left
          linefeed: 1,
        ));

      }

      double totalBillAmount = 0;

      // Calculate total bill amount
      for (var item in tableData) {
        totalBillAmount += double.parse(item['item_amt']);
      }

      list.add((LineText(
        type: LineText.TYPE_TEXT,
        content: "Total: ${totalBillAmount.toStringAsFixed(2)}",
        align: LineText.ALIGN_RIGHT,
        linefeed: 1,
      )));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: "----------------------------------------", // Empty content for space
        width: 2, // Adjust this value to control the amount of space on the left
        linefeed: 1,
      ));

      await bluetoothPrint.printReceipt(config, list);

      print('Bluetooth Result is:${bluetoothPrint.state}');
    } catch (e, stackTrace) {
      print('Printing error: $e');
      print('Stack trace: $stackTrace');
    }
  }

}


