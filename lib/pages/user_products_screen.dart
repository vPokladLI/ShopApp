import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/products_provider.dart';
import '../pages/edit_product_screen.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});
  static const routName = '/user/products';

  @override
  Widget build(BuildContext context) {
    void addItem() {
      Navigator.of(context).pushNamed(EditProductScreen.routName);
    }

    final products = context.watch<Products>();
    final user = Provider.of<User>(context, listen: false);
    Future<void> refreshItems() async {
      products.fetchAndSetProducts(user.uid);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [IconButton(onPressed: addItem, icon: const Icon(Icons.add))],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: refreshItems,
        child: products.allItems.isEmpty
            ? const Center(
                child: Text('No products found! Try later...'),
              )
            : Padding(
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
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    EditProductScreen.routName,
                                    arguments: products.allItems[i].id);
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                          IconButton(
                              onPressed: () {
                                products
                                    .deleteProduct(products.allItems[i].id!);
                              },
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
      ),
      floatingActionButton:
          // ignore: prefer_const_constructors
          FloatingActionButton(onPressed: addItem, child: Icon(Icons.add)),
    );
  }
}
