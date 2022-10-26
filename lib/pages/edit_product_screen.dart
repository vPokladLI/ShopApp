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
  var _editedProduct = Product(
      id: null,
      title: '',
      description: '',
      imageUrl: '',
      price: 0,
      isFavorite: false);

  var _initValues = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': ''
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocus.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId as String);

        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'imageUrl': '',
          'price': _editedProduct.price.toString()
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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

  Future _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState!.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct)
          .then((_) {
        _isLoading = false;
        Navigator.of(context).pop();
      }).onError((error, stackTrace) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .then((_) {
        _isLoading = false;
        Navigator.of(context).pop();
      }).onError((error, stackTrace) {
        setState(() {
          _isLoading = false;
        });
      });
    }
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(18),
              child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Title'),
                          initialValue: _initValues['title'],
                          autocorrect: true,
                          textInputAction: TextInputAction.next,
                          onSaved: (newValue) {
                            _editedProduct = Product(
                                title: newValue!,
                                isFavorite: _editedProduct.isFavorite,
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
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                          initialValue: _initValues['description'],
                          autocorrect: true,
                          maxLines: 2,
                          keyboardType: TextInputType.multiline,
                          validator: ValidationBuilder()
                              .minLength(10, 'At least 10 characters')
                              .build(),
                          onSaved: (newValue) {
                            _editedProduct = Product(
                                title: _editedProduct.title,
                                isFavorite: _editedProduct.isFavorite,
                                id: _editedProduct.id,
                                imageUrl: _editedProduct.imageUrl,
                                price: _editedProduct.price,
                                description: newValue!);
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Price'),
                          initialValue: _initValues['price'],
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
                                isFavorite: _editedProduct.isFavorite,
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
                          decoration:
                              const InputDecoration(labelText: 'Image URL'),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.url,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocus,
                          validator: ValidationBuilder()
                              .url('Image URL is not valid!')
                              .minLength(3, 'Image URL can\'t be empty')
                              .build(),
                          onSaved: (newValue) {
                            _editedProduct = Product(
                                title: _editedProduct.title,
                                id: _editedProduct.id,
                                imageUrl: newValue!,
                                price: _editedProduct.price,
                                description: _editedProduct.description);
                          },
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
