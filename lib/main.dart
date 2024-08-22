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
      title: 'products App',
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

  Future<void> readExcelFile() async {
    String? path = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']).then((result) {
      return result?.files.single.path;
    });

    if (path != null) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('productts List'),
        actions: [
          IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: readExcelFile,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product['product_name_en'] ?? 'Unknown'),
            subtitle: Text('Price: ${product['price_aed'] ?? 'N/A'} AED'),
          );
        },
      ),
    );
  }
}
