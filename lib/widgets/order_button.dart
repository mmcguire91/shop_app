import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/orders.dart';

class OrderButton extends StatefulWidget {
  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  //establish a variable for us to be able to change the value of that will affect the loading spinner

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    //setting the cartprovider to an easily referenceable variable, `cart`
    return TextButton(
      child: _isLoading
          ? CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            )
          //if _isLoading = true (we defined below that this occurs while the API call is made) then show the Loading spinner
          :
          //if _isLoading = false (we defined below that this occurs while the API call is made) then display the TextButton
          Text('order now'.toUpperCase()),
      onPressed: (cart.totalAmount <= 0 || _isLoading)
          ? null
          //if the value total amount from the cart provider <= 0 (there are no items in the cart) OR _isLoading = true [the circular progress indicator is displayed], the TextButton will not be clickable
          :
          //otherwise perform the behavior defined for the onPressed function
          () async {
              setState(() {
                _isLoading = true;
              });
              //set the state of _isLoading = true, starts the loading spinner. Display during the API call

              //call the CREATE API for Orders
              await Provider.of<Orders>(context, listen: false).addOrders(
                cartProducts: cart.items.values.toList(),
                //convert cart item objects into a list of cart item objects
                total: cart.totalAmount,
                //set the total to the total amount retrieved from the Cart provider
              );
              //execute the addOrder function established in orders.dart
              setState(() {
                _isLoading = false;
              });
              //set the state of _isLoading = false, stops the loading spinner. Stops display after API call is complete
              cart.clearCart();
              //empty the cart
              Navigator.of(context).pushNamed('/orders');
              //send the user to the orders page
            },
    );
  }
}
