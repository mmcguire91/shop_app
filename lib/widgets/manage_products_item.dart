import 'package:flutter/material.dart';

class ManageProductsItem extends StatelessWidget {
  ManageProductsItem({this.title, this.imageURL});

  final String title;
  final String imageURL;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageURL),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        //established a fixed width so that the Row doesn't cannabalize the ListTile
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
