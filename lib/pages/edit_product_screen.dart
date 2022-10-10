import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routName = '/edit-product';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
            child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                autocorrect: true,
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                autocorrect: true,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
                keyboardType: TextInputType.multiline,
                // textInputAction: TextInputAction.next,
              ),
              TextFormField(
                autocorrect: true,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                autocorrect: true,
                decoration: const InputDecoration(labelText: 'Image URL'),
                textInputAction: TextInputAction.next,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
