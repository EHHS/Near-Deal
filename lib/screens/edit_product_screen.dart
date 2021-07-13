import 'package:ayz_eh/providers/auth.dart';
import 'package:ayz_eh/providers/screen_arguments.dart';
import 'package:ayz_eh/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../providers/product.dart';
import '../providers/products.dart';
import '../providers/category.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _brandFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    name: '',
    description: '',
    image_url: '',
    category: '',
    brand: '',
  );
  var _initValues = {
    'name': '',
    'description': '',
    'image_url': '',
    'category': '',
    'brand': '',
  };
  var _isInit = true;
  var _isLoading = false;
  File _pickedImage;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCategory = _dropdownMenuItems[0].value;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
      final productId = args.productId;
      print(productId);
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'name': _editedProduct.name,
          'description': _editedProduct.description,
          'imageUrl': _editedProduct.image_url,
          'category': _editedProduct.category,
          'brand': _editedProduct.brand
        };
        _imageUrlController.text = _editedProduct.image_url;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _brandFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      return;
      setState(() {});
    }
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
    var args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    String userId = Provider.of<Auth>(context, listen: false).userId;
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false).updateProduct(
          args.shopId, _editedProduct.id, _editedProduct, userId, _pickedImage);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct, args.shopId, userId, _pickedImage);
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
      // finally{
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  List<Category> _companies = Category.getCategory();
  List<DropdownMenuItem<Category>> _dropdownMenuItems;
  Category _selectedCategory;

  List<DropdownMenuItem<Category>> buildDropdownMenuItems(List categories) {
    List<DropdownMenuItem<Category>> items = List();
    for (Category category in categories) {
      items.add(
        DropdownMenuItem(
          value: category,
          child: Text(category.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Category selectedCategory) {
    _editedProduct = Product(
      name: _editedProduct.name,
      description: _editedProduct.description,
      image_url: _editedProduct.image_url,
      id: _editedProduct.id,
      brand: _editedProduct.brand,
      category: selectedCategory.name,
    );
    setState(() {
      _selectedCategory = selectedCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
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
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          initialValue: _initValues['name'],
                          decoration: InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_brandFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a name.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                name: value,
                                description: _editedProduct.description,
                                image_url: _editedProduct.image_url,
                                id: _editedProduct.id,
                                category: _editedProduct.category,
                                brand: _editedProduct.brand);
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
                          initialValue: _initValues['brand'],
                          decoration: InputDecoration(labelText: 'brand'),
                          textInputAction: TextInputAction.next,
                          focusNode: _brandFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a brand.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            print(value);
                            _editedProduct = Product(
                              name: _editedProduct.name,
                              description: _editedProduct.description,
                              image_url: _editedProduct.image_url,
                              id: _editedProduct.id,
                              brand: value,
                              category: _editedProduct.category,
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
                            _editedProduct = Product(
                                name: _editedProduct.name,
                                description: value,
                                image_url: _editedProduct.image_url,
                                id: _editedProduct.id,
                                category: _editedProduct.category,
                                brand: _editedProduct.brand);
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
                        child: ListTile(
                          leading: Text("Select a Category"),
                          trailing: DropdownButton(
                            value: _selectedCategory,
                            items: _dropdownMenuItems,
                            onChanged: onChangeDropdownItem,
                          ),
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
                        child: Text('Selected: ${_selectedCategory.name}'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
