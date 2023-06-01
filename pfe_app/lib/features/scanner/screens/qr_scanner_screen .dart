import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  String qrCodeResult = "";

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
            Text(
              "Scan Result:",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Text(
              qrCodeResult,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // String codeScanner = await BarcodeScanner.scan();
                ScanResult qrScanResult = await BarcodeScanner.scan();
                String codeScanner = qrScanResult.rawContent;
                setState(() {
                  qrCodeResult = codeScanner;
                });
              },
              child: Text("Scan QR Code"),
            ),
          ],
        ),
      ),
    );
  }
}
