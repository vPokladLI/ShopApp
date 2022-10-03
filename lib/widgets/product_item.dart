import 'package:flutter/material.dart';
import '../pages/product_detailed_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const ProductItem(
      {super.key,
      required this.id,
      required this.imageUrl,
      required this.title});

  @override
  Widget build(BuildContext context) {
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
            leading: IconButton(
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {},
                icon: const Icon(Icons.favorite)),
            backgroundColor: Colors.black87,
            title: Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
            ),
            trailing: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductDetailedScreen.routName, arguments: id);
            },
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
