import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/product_arguments.dart';
import '../providers/products.dart';
import '../providers/screen_arguments.dart';
import '../screens/search_result_screen.dart';

class SearchProductScreen extends StatefulWidget {
  static const routeName = '/search-products';

  @override
  _SearchProductScreenState createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  List<Product> _results = [];

  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  String _value;

  Future<void> _saveForm() async {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    final shopId = args.shopId;
    final shopName = args.shopName;
    final shopImageUrl = args.shopImageUrl;
    final isValid = _form.currentState.validate();
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();

    try {
      _results = await Provider.of<Products>(context, listen: false)
          .fetchAndSetProductbyName(_value);
      Navigator.of(context).pushNamed(SearchResultScreen.routeName,
          arguments: ProductArguments(shopId, _results,shopName,shopImageUrl));
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occurred'),
          content: Text('Something went wrong'),
          actions: <Widget>[
            FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                })
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    final shopId = args.shopId;
    final shopName = args.shopName;
    final shopImageUrl = args.shopImageUrl;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Products to add'),
        backgroundColor: Color.fromRGBO(225, 245, 240, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(25, 118, 210, 1).withOpacity(0.5),
                    Color.fromRGBO(13, 71, 161, 1).withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1],
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(25, 118, 210, 1).withOpacity(0.5),
                    Color.fromRGBO(13, 71, 161, 1).withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1],
                ),
              ),
              child: Form(
                key: _form,
                child: Padding(
                  padding: const EdgeInsets.all(60),
                  child: Column(
                    children: [
                        AnimatedContainer(
                          margin: EdgeInsets.only(bottom: 5.0),
                          padding: EdgeInsets.all(10),
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                          width: deviceSize.width * 0.75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child:Text('Enter the product you want to search'),
                        ),

                       SizedBox(
                          width: deviceSize.width * 0.75,
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Title'),
                              textInputAction: TextInputAction.search,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please provide a value.';
                                }
                                return null;
                              },
                              onSaved: (value) async {
                                _value = value;
                              },
                            ),
                          ),
                        ),

                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
