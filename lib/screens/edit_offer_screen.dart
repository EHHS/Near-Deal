import 'dart:io';
import 'package:ayz_eh/providers/screen_arguments.dart';
import 'package:ayz_eh/screens/offers_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import '../providers/auth.dart';
import '../providers/offer.dart';
import '../providers/offers.dart';

class EditOfferScreen extends StatefulWidget {
  static const routeName = '/edit-offer';

  @override
  _EditOfferScreenState createState() => _EditOfferScreenState();
}

class _EditOfferScreenState extends State<EditOfferScreen> {
  final _locationFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedOffer = Offer(
    id: null,
    amount: 0,
    price: 0,
    product_id: '',
    shop_id: '',
  );
  var _initValues = {
    'id': '',
    'amount': '',
    'price': '',
    'product_id': '',
    'shop_id': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
      final offerId = args.offerId;
      if (offerId != null) {
        _editedOffer =
            Provider.of<Offers>(context, listen: false).findById(offerId);
        _initValues = {
          'amount': _editedOffer.amount.toString(),
          'price': _editedOffer.price.toString(),
          'product_id': _editedOffer.product_id,
          'shop_id': _editedOffer.shop_id,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _locationFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      return;
    }
    setState(() {});
  }

  Future<void> _saveForm() async {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    final shopId = args.shopId;
    final shopName = args.shopName;
    final shopImageUrl = args.shopImageUrl;
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedOffer.id != null) {
      await Provider.of<Offers>(context, listen: false)
          .updateOffer(_editedOffer.id, _editedOffer);
    } else {
      try {
        await Provider.of<Offers>(context, listen: false)
            .addOffer(_editedOffer);
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
                    Navigator.of(context).pushNamed(OfferListScreen.routeName,
                        arguments: ScreenArguments(shopId, null, null,shopName,shopImageUrl));
                  })
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushNamed(OfferListScreen.routeName,
        arguments: ScreenArguments(shopId, null, null,shopName,shopImageUrl));
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    final shopId = args.shopId;
    final productId = args.productId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit offer'),
        backgroundColor: Color.fromRGBO(225, 245, 240, 1),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                    children: <Widget>[

                      Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          initialValue: _initValues['price'],
                          decoration: InputDecoration(labelText: 'price'),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a price.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedOffer = Offer(
                              price: double.parse(value),
                              amount: _editedOffer.amount,
                              product_id: productId,
                              shop_id: shopId,
                              id: _editedOffer.id,
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          initialValue: _initValues['amount'],
                          decoration: InputDecoration(labelText: 'amount'),
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter an amount.';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _editedOffer = Offer(
                              price: _editedOffer.price,
                              amount: int.parse(value),
                              product_id: productId,
                              shop_id: shopId,
                              id: _editedOffer.id,
                            );
                          },
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
