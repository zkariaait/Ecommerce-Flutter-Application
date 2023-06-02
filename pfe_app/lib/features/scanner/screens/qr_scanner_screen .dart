import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:pfe_app/features/product_details/screens/product_details_screen.dart';
import 'package:pfe_app/models/product.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  String qrCodeResult = "";
  Product product = Product(
    id: '',
    name: '',
    description: '',
    quantity: 0,
    images: [],
    category: '',
    price: 0.0,
    manufacturer: '',
    rating: [],
    qrCode: '',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                ScanResult qrScanResult = await BarcodeScanner.scan();
                String codeScanner = qrScanResult.rawContent;

                final key = encrypt.Key.fromLength(32);
                final iv = encrypt.IV.fromLength(16);
                final encrypter = Encrypter(AES(key));

                try {
                  // Try parsing the QR code data as JSON
                  final parsedData = json.decode(codeScanner);

                  // Handle the case when the QR code data is not encrypted (e.g., plain JSON)
                  setState(() {
                    qrCodeResult = codeScanner;
                    product = parseQRCodeData(codeScanner);
                  });
                } catch (_) {
                  // QR code data is not in a valid JSON format, assume it's encrypted
                  final decryptedRes = encrypter.decrypt64(codeScanner, iv: iv);

                  setState(() {
                    qrCodeResult = codeScanner;
                    product = parseQRCodeData(decryptedRes);
                  });
                }
              },
              child: Text("Scan QR Code"),
            ),
            SizedBox(height: 20.0),
            if (product.name != null)
              Column(
                children: [
                  Image.network(
                    product.images.isNotEmpty ? product.images[0] : '',
                    height: 100.0,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    product.id!,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the product screen using the productData
                      // You can pass the productData as arguments to the product screen
                      print(product.toJson());
                      Navigator.pushNamed(
                        context,
                        ProductDetailScreen.routeName,
                        arguments: product,
                      );
                    },
                    child: Text("Buy " + product.name),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Product parseQRCodeData(String codeScanner) {
    try {
      Map<String, dynamic> jsonData = json.decode(codeScanner);
      Product product = Product.fromMap(jsonData);
      //  String? productId = jsonData['productId'];
      // print('00000000000000000000000000000000000000$productId');
      return product;
    } catch (e) {
      print("Error parsing QR code data: $e");
      return Product(
        id: '',
        name: '',
        description: '',
        quantity: 0,
        images: [],
        category: '',
        price: 0.0,
        manufacturer: '',
        rating: [],
        qrCode: '',
      );
    }
  }
}
