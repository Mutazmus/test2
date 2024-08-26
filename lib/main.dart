import 'dart:io';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Products App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PerfumeListScreen(),
    );
  }
}

class PerfumeListScreen extends StatefulWidget {
  @override
  _PerfumeListScreenState createState() => _PerfumeListScreenState();
}

class _PerfumeListScreenState extends State<PerfumeListScreen> {
  List<Map<String, dynamic>> products = [];
  bool _isLoading = false;

  Future<void> readExcelFile() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
      if (result != null && result.files.single.path != null) {
        String path = result.files.single.path!;
        var file = File(path);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        List<Map<String, dynamic>> tempProducts = [];
        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]!.rows) {
            if (row.isNotEmpty) {
              Map<String, dynamic> product = {
                'photo': row[0]?.value,
                'price_aed': row[1]?.value,
                'product_description_en': row[2]?.value,
                'product_description_ar': row[3]?.value,
                'product_name_ar': row[4]?.value,
                'product_name_en': row[5]?.value,
                'barcode': row[6]?.value,
                'qty': row[7]?.value,
              };
              tempProducts.add(product);
            }
          }
        }

        setState(() {
          products = tempProducts;
        });
      }
    } catch (e) {
      print("Error reading file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to read Excel file')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products List'),
        actions: [
          IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: readExcelFile,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(child: Text('No data available'))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Photo')),
                      DataColumn(label: Text('Price AED')),
                      DataColumn(label: Text('Description (EN)')),
                      DataColumn(label: Text('Description (AR)')),
                      DataColumn(label: Text('Name (AR)')),
                      DataColumn(label: Text('Name (EN)')),
                      DataColumn(label: Text('Barcode')),
                      DataColumn(label: Text('Quantity')),
                    ],
                    rows: products.map((product) {
                      return DataRow(cells: [
                        DataCell(product['photo'] != null ? Image.network(product['photo'].toString(), width: 50, height: 50) : Text('No Image')),
                        DataCell(Text(product['price_aed']?.toString() ?? 'N/A')),
                        DataCell(Text(product['product_description_en']?.toString() ?? '')),
                        DataCell(Text(product['product_description_ar']?.toString() ?? '')),
                        DataCell(Text(product['product_name_ar']?.toString() ?? '')),
                        DataCell(Text(product['product_name_en']?.toString() ?? '')),
                        DataCell(Text(product['barcode']?.toString() ?? '')),
                        DataCell(Text(product['qty']?.toString() ?? '0')),
                      ]);
                    }).toList(),
                  ),
                ),
    );
  }
}
