import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  ProductItem({
    this.id,
    this.title,
    this.imageURL,
  });

  final String id;
  final String title;
  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      //ClipRRect forces the child to adhere to speceific defined styling properties
      //ClipRRect stands for clip rounded rectangles
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: Image.network(
          imageURL,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
