import 'package:billing_app/print_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String _formatDate(String rawDate) {
  DateTime dateTime = DateTime.parse(rawDate);
  String formattedDate = '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  return formattedDate;
}

class TableDataDisplay {
  static Future<List<Map<String, dynamic>>> fetchTableData(String latestInvoiceId) async {
    try {
      final apiUrl = 'https://apip.trifrnd.com/Fruits/inv.php?apicall=readinv';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'inv_id': latestInvoiceId},
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to fetch table data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching table data: $e');
      throw Exception('Failed to fetch table data');
    }
  }

  static Future<void> displayTableData(BuildContext context, String latestInvoiceId) async {
    try {
      final List<Map<String, dynamic>> tableData = await fetchTableData(latestInvoiceId);

      double totalBillAmount = tableData
          .map((item) => double.parse(item['item_amt'].toString()))
          .fold(0, (previous, current) => previous + current);

      showDialog(
        context: Navigator.of(context, rootNavigator: true).overlay?.context ?? context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text('Invoice')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Invoice ID $latestInvoiceId',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 100,),
                    ],
                  ),
                  if (tableData.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(width: 100,),
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
                            TableCell(child: Text('${tableData[index]['item_name']}  ')),
                            TableCell(child: Text('  ${tableData[index]['item_price']}  ',)),
                            TableCell(child: Center(child: Text('  ${tableData[index]['qty']}  '))),
                            TableCell(
                              child: Center(
                                child: Text(
                                  '  ${tableData[index]['item_amt']}  ',
                                ),
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
                                '${totalBillAmount.toStringAsFixed(2)}  ',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (_) => PrintPage(data: tableData)));
                },
                child: const Text('Print'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error displaying table data: $e');
      throw Exception('Failed to display table data');
    }
  }
}
