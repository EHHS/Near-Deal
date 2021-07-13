import 'dart:io';
import 'package:ayz_eh/models/place.dart';
import 'package:ayz_eh/providers/screen_arguments.dart';
import 'package:ayz_eh/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/shop.dart';
import '../providers/shops.dart';

class EditShopScreen extends StatefulWidget {
  static const routeName = '/edit-shop';

  @override
  _EditShopScreenState createState() => _EditShopScreenState();
}

class _EditShopScreenState extends State<EditShopScreen> {
  final _locationFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedShop = Shop(
    id: null,
    name: '',
    created_by: '',
    description: '',
    image_url: '',
    geohash: '',
    lon: '',
    lat: '',
  );
  var _initValues = {
    'name': '',
    'description': '',
    'created_by': '',
    'image_url': '',
    'geohash': '',
    'lon': '',
    'lat': '',
  };
  var _isInit = true;
  var _isLoading = false;

  File _pickedImage;
  PlaceLocation _pickedLocation;

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
      final shopId = args.shopId;
      if (shopId != null) {
        _editedShop =
            Provider.of<Shops>(context, listen: false).findById(shopId);
        _initValues = {
          'name': _editedShop.name,
          'description': _editedShop.description,
          'created_by': _editedShop.created_by,
          'imageUrl': _editedShop.image_url,
          'geohash': _editedShop.geohash,
          'lon': _editedShop.lon,
          'lat': _editedShop.lat,
        };
        _imageUrlController.text = _editedShop.image_url;
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

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _pickedImage = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _pickedImage = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid || _pickedImage == null || _pickedLocation == null) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedShop.id != null) {
      String userId = Provider.of<Auth>(context, listen: false).userId;
      await Provider.of<Shops>(context, listen: false).updateShop(
          _editedShop.id, _editedShop, _pickedImage, _pickedLocation, userId);
    } else {
      try {
        String userId = Provider.of<Auth>(context, listen: false).userId;
        await Provider.of<Shops>(context, listen: false)
            .addShop(_editedShop, userId, _pickedImage, _pickedLocation);
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
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Shop'),
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
              child: Form(
                key: _form,
                child: ListView(
                  padding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                  children: <Widget>[
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Color(0xffFDCF09),
                            child: _pickedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                      _pickedImage,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        initialValue: _initValues['name'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedShop = Shop(
                            name: value,
                            created_by: _editedShop.created_by,
                            description: _editedShop.description,
                            image_url: _editedShop.image_url,
                            id: _editedShop.id,
                            lon: _editedShop.lon,
                            lat: _editedShop.lat,
                            geohash: _editedShop.geohash,
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      padding:
                      EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 2,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a description.';
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedShop = Shop(
                            name: _editedShop.name,
                            created_by: _editedShop.created_by,
                            description: value,
                            image_url: _editedShop.image_url,
                            id: _editedShop.id,
                            geohash: _editedShop.geohash,
                            lat: _editedShop.lat,
                            lon: _editedShop.lon,
                          );
                        },
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 5.0),

                        padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: LocationInput(_selectPlace)),
                    //ImageInput(_selectImage),
                  ],
                ),
              ),
            ),
    );
  }
}
