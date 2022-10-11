import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routName = '/edit-product';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: '1', title: '', description: '', imageUrl: '', price: 0);

  @override
  void initState() {
    _imageUrlFocus.addListener(_updateImage);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlController.dispose();
    _imageUrlFocus.dispose();
    _imageUrlFocus.removeListener(_updateImage);
  }

  void _updateImage() {
    if (!_imageUrlFocus.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product page'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    autocorrect: true,
                    decoration: const InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    onSaved: (newValue) {
                      _editedProduct = Product(
                          title: newValue!,
                          id: _editedProduct.id,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          description: _editedProduct.description);
                    },
                    validator: ValidationBuilder()
                        .minLength(1, 'Title can`t be empty')
                        .build(),
                  ),
                  TextFormField(
                    autocorrect: true,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 2,
                    keyboardType: TextInputType.multiline,
                    validator: ValidationBuilder()
                        .minLength(10, 'At least 10 characters')
                        .build(),
                    onSaved: (newValue) {
                      _editedProduct = Product(
                          title: _editedProduct.title,
                          id: _editedProduct.id,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          description: newValue!);
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the price!';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Price must be a number';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Price must be greater then zero';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _editedProduct = Product(
                          title: _editedProduct.title,
                          id: _editedProduct.id,
                          imageUrl: _editedProduct.imageUrl,
                          price: double.parse(newValue!),
                          description: _editedProduct.description);
                    },
                  ),
                  if (_imageUrlController.text.isNotEmpty)
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: FittedBox(
                          child: Image.network(
                        _imageUrlController.text,
                        fit: BoxFit.cover,
                      )),
                    ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Image URL'),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.url,
                    controller: _imageUrlController,
                    focusNode: _imageUrlFocus,
                    validator: ValidationBuilder()
                        .url('Image URL is not valid!')
                        .minLength(3, 'Image URL can\'t be empty')
                        .build(),
                    onSaved: (newValue) => Product(
                        title: _editedProduct.title,
                        id: _editedProduct.id,
                        imageUrl: newValue!,
                        price: _editedProduct.price,
                        description: _editedProduct.description),
                    onEditingComplete: () {
                      setState(() {});
                    },
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
