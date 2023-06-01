import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pfe_app/admin/services/admin_services.dart';
import 'package:pfe_app/common/widgets/custom_button.dart';
import 'package:pfe_app/common/widgets/custom_textfield.dart';
import 'package:pfe_app/constants/global_variables.dart';
import 'package:pfe_app/constants/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/src/foundation/key.dart' as flutter_key;

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({flutter_key.Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final AdminServices adminServices = AdminServices();

  String category = 'MOBILES'; // Updated enum constant
  List<File> images = [];

  final _addProductFormKey = GlobalKey<FormState>();

  String qrCodeData = '';
  bool test = false;

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  List<String> productCategories = [
    'MOBILES',
    'FURNITURE',
    'ELECTRONICS',
    'BOOKS',
    'CLOTHING'
  ];
  Future<void> sellProduct() async {
    String a = await adminServices.sellProduct(
      context: context,
      name: productNameController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      quantity: int.parse(quantityController.text),
      category: category,
      images: images,
    );
    print('a: $a');
    File QR = (await saveQrCodeImage(a))!;
    adminServices.updateProductInCatalog(file: QR, jsonString: a);
    generateQRCodeFromJson(a);
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  Future<File?> saveQrCodeImage(String qrCodeData) async {
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    final encryptedqrCodeData = encrypter.encrypt(qrCodeData, iv: iv).base64;

    final qrPainter = QrPainter(
      data: encryptedqrCodeData,
      version: QrVersions.auto,
      gapless: false,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );
    final imageSize = 200.0;
    final imageBytes = await qrPainter.toImageData(imageSize);
    print('00$qrCodeData');
    if (imageBytes != null) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/qr_code.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes.buffer.asUint8List());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('QR code image saved successfully'),
        ),
      );
      return file;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save QR code image'),
        ),
      );
      return null;
    }
  }

  void generateQRCodeFromJson(String jsonString) {
    final jsonData = json.decode(jsonString);
    final int productId = jsonData['productId'];
    final String productName = jsonData['productName'];
    final double price = jsonData['price'];
    final List<dynamic> images = jsonData['images'];

    final String data = json.encode({
      'productId': productId,
      'productName': productName,
      'price': price,
      'images': images,
    });
    setState(() {
      final key = encrypt.Key.fromLength(32);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = Encrypter(AES(key));

      final encryptedqrCodeData = encrypter.encrypt(qrCodeData, iv: iv).base64;

      qrCodeData = encryptedqrCodeData;
      test = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            'Add Product',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                images.isNotEmpty
                    ? CarouselSlider(
                        items: images.map(
                          (i) {
                            return Builder(
                              builder: (BuildContext context) => Image.file(
                                i,
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Select Product Images',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: productNameController,
                  hintText: 'Product Name',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  maxLines: 7,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: priceController,
                  hintText: 'Price',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: quantityController,
                  hintText: 'Quantity',
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: productCategories.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        category = newVal!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  color: Colors.black12,
                  text: 'Sell',
                  onTap: () {
                    sellProduct();
                    Future.delayed(Duration(seconds: 5), () {
                      if (test == true) {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  QrImageView(
                                    data: qrCodeData,
                                    version: QrVersions.auto,
                                    size: 200.0,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Scan the QR code to view product information',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                        test = false;
                      }
                    });
                    //i want to wait a 2 sec before showing the modal
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    //  generateQRCodeData();
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              QrImageView(
                                data: qrCodeData,
                                size: 200,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Scan the QR code to view product information',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Generate QR Code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
