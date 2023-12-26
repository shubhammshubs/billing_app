import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PrintPage extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const PrintPage({Key? key, required this.data}) : super(key: key);

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String _deviceMsg = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await enableBluetooth();
      initPrinter();
    });
  }

  Future<void> requestAndProceedWithBluetooth() async {
    // Request location permission
    var status = await Permission.location.request();

    // Check if location permission is granted
    if (status.isGranted) {
      // Location permission is granted, proceed with Bluetooth operations
      // Example: Start Bluetooth scanning
      startBluetoothScanning();
    } else {
      // Location permission is not granted
      // Handle accordingly, and consider explaining to the user why the permission is needed
      // You might want to show a dialog or guide the user to grant the necessary permission
    }
  }

  void startBluetoothScanning() {
    // Implement your Bluetooth scanning logic here
    // This is where you would use the `bluetooth_print` or any other Bluetooth-related package
    // to initiate scanning for nearby Bluetooth devices, connect to devices, etc.
  }

  Future<void> enableBluetooth() async {
    // On Android, you can check and request Bluetooth permissions here
    // On iOS, Bluetooth is enabled through the system settings, so no direct API call is available
    // You might want to show a message to the user to enable Bluetooth manually on iOS
    // For Android, you can use a package like permission_handler to request permissions
  }

  Future<void> initPrinter() async {
    bluetoothPrint.startScan(timeout: Duration(milliseconds: 500));

    if (!mounted) return;
    bluetoothPrint.scanResults.listen((val) {
      if (!mounted) return;
      setState(() {
        _devices = val;
      });
      if (_devices.isEmpty)
        setState(() {
          _deviceMsg = "No Devices Found";
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Printer "),
        backgroundColor: Colors.orange,
      ),
      body: _devices.isEmpty
          ? Center(child: Text(_deviceMsg ?? ''))
          : ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (c, i) {
          return ListTile(
            leading: Icon(Icons.print),
            title: Text(_devices[i].name ?? ''),
            subtitle: Text(_devices[i].address ?? ''),
            onTap: () {
              // Handle onTap logic here
              connectAndPrint(_devices[i]);
            },
          );
        },
      ),
    );
  }

  Future<void> connectAndPrint(BluetoothDevice device) async {
    // Connect to the Bluetooth printer
    bool isConnected = await bluetoothPrint.connect(device);

    if (isConnected) {
      print('Connected to ${device.name}');
      // Now you can send print commands to the printer
      sendPrintCommand();
    } else {
      print('Failed to connect to ${device.name}');
      // Handle connection failure
    }
  }


  void sendPrintCommand() {
    // Perform any setup or additional logic before sending the print command

    // Example: Print a test message
    String message = 'Hello, this is a test print!';
    bluetoothPrint.printTest();Text(message);

    // Note: Replace writeText with the correct method if it's different in the package.
    // Refer to the documentation or source code of the bluetooth_print package for accurate method names.
  }
}
