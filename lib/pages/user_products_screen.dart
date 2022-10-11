import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../pages/edit_product_screen.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});
  static const routName = '/user/products';

  @override
  Widget build(BuildContext context) {
    void editItem() {
      Navigator.of(context).pushNamed(EditProductScreen.routName);
    }

    final products = context.watch<Products>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.separated(
          itemCount: products.allItems.length,
          separatorBuilder: (context, index) => Divider(
            thickness: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
          itemBuilder: (_, i) => ListTile(
            title: Text(products.allItems[i].title),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                products.allItems[i].imageUrl,
              ),
            ),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                      onPressed: editItem,
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.secondary,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton:
          // ignore: prefer_const_constructors
          FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
    );
  }
}
