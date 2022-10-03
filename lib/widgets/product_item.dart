import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/product_detailed_screen.dart';
import '../providers/product_provider.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 4,
              offset: const Offset(3, 3),
            ),
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (_, product, __) => IconButton(
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: product.toggleFavorite,
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_outline)),
            ),
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
            ),
            trailing: Consumer<Cart>(
              builder: (_, cart, __) => IconButton(
                color: Theme.of(context).colorScheme.secondary,
                icon: Icon(cart.isInCart(product.id)
                    ? Icons.shopping_cart
                    : Icons.shopping_cart_outlined),
                onPressed: () {
                  cart.addItem(
                      productId: product.id,
                      title: product.title,
                      price: product.price);
                },
              ),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailedScreen.routName,
                  arguments: product.id);
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
