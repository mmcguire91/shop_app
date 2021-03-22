import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_products_screen.dart';
import '../models/products_provider.dart';

class ManageProductsItem extends StatelessWidget {
  ManageProductsItem({this.id, this.title, this.imageURL});

  final String id;
  final String title;
  final String imageURL;
  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    //because we are trying to call ScaffoldMessenger.of(context) within a future it doesn't know which context we are referring to and throws an error, therefore we are setting it to a local variable and then calling on that variable in the future method
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
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductsScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<ProductsProvider>(context, listen: false)
                      .deleteProduct(id);
                  //await if the delete API call can be successfully made
                } catch (error) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Delete failed',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
