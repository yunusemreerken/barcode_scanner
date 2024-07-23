import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BarcodeScannerScreen(),
    );
  }
}

class BarcodeScannerScreen extends StatefulWidget {
  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  String _scanResult = 'Henüz taranmadı';

  Future<void> startBarcodeScan() async {
    String scanResult;
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'İptal', true, ScanMode.BARCODE);
      if (scanResult == '-1') {
        scanResult = 'Taramadan çıkıldı';
      }
    } catch (e) {
      scanResult = 'Taramada hata: $e';
    }

    setState(() {
      _scanResult = scanResult;
    });
  }


  Future<void> saveProduct(String name, double price, int barcode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('product_name', name);
    await prefs.setDouble('product_price', price);
    await prefs.setInt('product_barcode', barcode);

  }

  Future<void> loadProduct() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('product_name') ?? 'No Name';
    final price = prefs.getDouble('product_price') ?? 0.0;
    final barcode = prefs.getInt('product_barcode') ?? 0000000000000000;

    print('Product Name: $name');
    print('Product Price: $price');
    print('Product Barcode: $barcode');
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barkod Tarayıcı'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Tarama Sonucu: $_scanResult'),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Tarama Sonucu: $_scanResult',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startBarcodeScan,
              child: Text('Barkod Tara'),
            ),
            ElevatedButton(
              onPressed: () async {
                await saveProduct("test", 33.4, 42);
              },
              child: Text('Urun Ekle'),
            ),
            ElevatedButton(
              onPressed: () async {
                await loadProduct();
              },
              child: Text('Urun Listele'),
            ),
          ],
        ),
      ),
    );
  }
}


  
