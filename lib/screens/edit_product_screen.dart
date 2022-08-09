import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screens/user_products_screen.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen({Key? key}) : super(key: key);
  static const routeName = "/edit-product-screen";
  final _formKey = GlobalKey<FormState>();
  final shoeImage =
      "https://st-adidas-egy.mncdn.com/content/images/thumbs/0117567_grand-court-shoes_ef0103_side-lateral-center-view.jpeg";
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void _saveProductInfo(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final editedProduct = Product(
        id: DateTime.now().toString(),
        title: titleController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        imageUrl: shoeImage,
      );

      Provider.of<ProductsProvider>(context, listen: false).addProduct(editedProduct);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: (){
                _saveProductInfo(context);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                child: Image(
                  image: NetworkImage(shoeImage),
                  fit: BoxFit.cover,
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
    );
  }
}