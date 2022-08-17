import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/product.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screens/user_products_screen.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';

class EditProductScreen extends StatefulWidget {
  EditProductScreen({Key? key}) : super(key: key);
  static const routeName = "/edit-product-screen";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _productImg;
  final shoeImage =
      "https://st-adidas-egy.mncdn.com/content/images/thumbs/0117567_grand-court-shoes_ef0103_side-lateral-center-view.jpeg";

  var currentImage = "";
  var currentID = "";

  TextEditingController titleController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  var _isUpdate = false;
  var _isLoading = false;
  var _isInit = true;

  void _pickImg() async {
    final picker = ImagePicker();
    final pickedImageXFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    final pickedImageFile = File(pickedImageXFile!.path);
    setState(() {
      _productImg = pickedImageFile;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final arg = ModalRoute.of(context)?.settings.arguments as String;
      if (arg != UserProductsScreen.routeName) {
        _isUpdate = true;
      }
      if (_isUpdate) {
        final currentProduct =
            Provider.of<ProductsProvider>(context, listen: false)
                .findProductById(arg);
        titleController.text = currentProduct.title;
        priceController.text = currentProduct.price.toString();
        descriptionController.text = currentProduct.description;
        currentImage = currentProduct.imageUrl;
        currentID = currentProduct.id;
      }
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    print("dispose dispose dispose dispose");
    super.dispose();
  }

  void _saveProductInfo(BuildContext context) async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      final additionalProduct = Product(
        id: DateTime.now().toString(),
        title: titleController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        imageUrl:
            'data:image/jpg;base64,${base64Encode(_productImg!.readAsBytesSync())}',
      );

      productsProvider.addProduct(additionalProduct, _productImg!).then(
        (value) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        },
      ).catchError((err) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Save Failed, check your connection and try again!"),
            duration: Duration(seconds: 3),
          ),
        );
      });
    }
  }

  void _updateProductInfo(BuildContext context, String id) {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      final updatedProduct = Product(
        id: id,
        title: titleController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        imageUrl: _productImg == null
            ? currentImage
            : 'data:image/jpg;base64,${base64Encode(_productImg!.readAsBytesSync())}',
      );

      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(updatedProduct)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }).catchError((error) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Update Failed, check your connection and try again!"),
            duration: Duration(seconds: 3),
          ),
        );
      });
      //Navigator.of(context).pop();
    }
  }
  Uint8List _getByteImg() => const Base64Decoder().convert(currentImage, 22);

  @override
  Widget build(BuildContext context) {

    print(_isLoading);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Product"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.check_circle_sharp,
                  size: 30,
                ),
                onPressed: () {
                  if (_isUpdate) {
                    _updateProductInfo(context, currentID);
                  } else {
                    _saveProductInfo(context);
                  }
                },
              ),
            ),
          ],
        ),
        body: ConditionalBuilder(
          condition: !_isLoading,
          builder: (ctx) => SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: InkWell(
                        onTap: () {
                          _pickImg();
                        },
                        child: _productImg == null
                            ? _isUpdate
                                ? Image.memory(
                                    _getByteImg(),
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    width: double.infinity,
                                  )
                                : const Center(child: Text("Add Image"))
                            : Image.file(
                                _productImg!,
                                fit: BoxFit.cover,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                width: double.infinity,
                              ),
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: "Title"),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please provide a value.";
                            }
                            return null;
                          },
                          controller: titleController,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: "Price"),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please provide a value.";
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number.';
                            }

                            if (double.parse(value) <= 0) {
                              return 'Please enter a number greater than zero.';
                            }
                            return null;
                          },
                          controller: priceController,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Description"),
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          maxLines: 3,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please provide a value.";
                            }
                            if (value.length < 10) {
                              return 'Should be at least 10 characters long.';
                            }
                            return null;
                          },
                          controller: descriptionController,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}
/*                      ? Image(
                                image: _productImg != null
                                    ? FileImage(_productImg!)
                                    : Image.memory(
                                        byteImg,
                                        fit: BoxFit.cover,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        width: double.infinity,
                                      ) as ImageProvider,
                                fit: BoxFit.cover,
                              )
                            : _productImg == null
                                ? const Center(
                                    child: Text(
                                      "Add image",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : Image(
                                    image: FileImage(_productImg!),
                                  ),*/
