import 'package:demoapplication/Screens/Inventory.dart';
import 'package:demoapplication/providers/Product.dart';
import 'package:demoapplication/providers/ScreenArguments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

import 'ImageCaptureScreen.dart';

class AddProductNormally extends StatefulWidget {
  static const routeName = "/addProduct";

  String shopName;
  @override
  _AddProductNormallyState createState() => _AddProductNormallyState();
}

class _AddProductNormallyState extends State<AddProductNormally> {
  bool _oneTimeSave = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _tittleFocusNode = FocusNode();

  final _priceFocusNode = FocusNode();
  final _dPriceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  bool ifElecOrFash = false;
  int imageNum = 0;
  bool alreadyProduct = false;
  List<dynamic> prevImage = [];
  TextEditingController _quantityController;
  TextEditingController _textTittleController;
  TextEditingController _textCategoryController;
  final _form = GlobalKey<FormState>();
  var _storedImage;
  var _storedImage1;
  bool _init = false;
  var _storedImage2;
  var _storedImage3;
  String Shopcategory;
  List<String> radioButtons2 = [];
  List<DropdownMenuItem> radioButtons = [];
  int selectedRadio = -1;
  dynamic extractedData;
  bool oneTimeRun = false;
  bool edit_product = false;
  List<String> imageUrls = [];
  String barcode = "";
  var _editedproduct = ProductDefinition(
    id: null,
    tittle: "",
    description: "",
    price: 0,
    imageUrl: "",
  );

  Future<bool> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return null;
    }
    _form.currentState.save();
    if (_editedproduct.imageUrl == "") {
      final snackBar = SnackBar(content: Text("Upload an image "));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return null;
    }

    final user = FirebaseAuth.instance.currentUser;
    ProductDefinition productObj = ProductDefinition();
    bool val = await productObj.addProtoFirebase(
        _editedproduct, user.uid, await user.getIdToken(true));
    return val;
  }

  var _initValues = {
    'tittle': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = false;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    _isInit = true;
    oneTimeRun = true;
    super.initState();
  }

  void _updateTittletext() {
    setState(() {});
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> didChangeDependencies() async {
    if (_isInit) {
      _textTittleController =
          TextEditingController(text: _initValues["tittle"]);
      _textTittleController.addListener(_updateTittletext);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  showAlertDialog(BuildContext context, String infoToShow) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text(infoToShow)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              "Add Product",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  showAlertDialog(context, "Uplaoding");
                  _saveForm().then((check) {
                    if (check == null) {
                      Navigator.pop(context);
                      return;
                    }
                    if (check) {
                      final snackBar =
                          SnackBar(content: Text("Successfully Uploded"));
                      _scaffoldKey.currentState.showSnackBar(snackBar);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      final snackBar =
                          SnackBar(content: Text("Uploading Failed "));
                      _scaffoldKey.currentState.showSnackBar(snackBar);
                    }
                  });
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Form(
              key: _form,
              child:
                  ListView(scrollDirection: Axis.vertical, children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _textTittleController,
                  autocorrect: true,
                  decoration: InputDecoration(labelText: "Tittle"),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Title  is  required";
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _editedproduct = ProductDefinition(
                      id: _editedproduct.id,
                      tittle: value,
                      description: _editedproduct.description,
                      price: _editedproduct.price,
                      imageUrl: _editedproduct.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initValues['price'],
                  autocorrect: true,
                  decoration: InputDecoration(labelText: "Selling Price"),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Price  is  required";
                    }
                    if (double.tryParse(value) == null) {
                      return "Price is not Valid Number";
                    }
                    if (double.parse(value) <= 0) {
                      return "Price cant  be zero";
                    }
                    if (double.tryParse(value) > 999999) {
                      return "Price is large , it should be under 999999";
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _editedproduct = _editedproduct = ProductDefinition(
                      id: _editedproduct.id,
                      tittle: _editedproduct.tittle,
                      description: _editedproduct.description,
                      price: double.parse(value),
                      imageUrl: _editedproduct.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initValues['description'],
                  autocorrect: true,
                  decoration: InputDecoration(labelText: "Decription"),
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  controller: _quantityController,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).unfocus();
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Description  is  required";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedproduct = ProductDefinition(
                      id: _editedproduct.id,
                      tittle: _editedproduct.tittle,
                      description: value,
                      price: _editedproduct.price,
                      imageUrl: _editedproduct.imageUrl,
                    );
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Center(
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                width: 80,
                                height: 80,
                                margin: EdgeInsets.only(
                                  top: 8,
                                  right: 10,
                                ),
                                decoration: BoxDecoration(
                                    color: Color(0xFF21BFBD),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(75.0))),
                                child: _storedImage == null
                                    ? GestureDetector(
                                        child: Center(
                                          child: Text('click'),
                                        ),
                                        onTap:
                                            _textTittleController.text.length ==
                                                    0
                                                ? () {
                                                    final snackBar = SnackBar(
                                                        content: Text(
                                                            "Please fill the Tittle before "));
                                                    _scaffoldKey.currentState
                                                        .showSnackBar(snackBar);
                                                  }
                                                : () {
                                                    captureImage();
                                                  })
                                    : FittedBox(
                                        child: GestureDetector(
                                            child: Image(
                                              image: FileImage(_storedImage),
                                            ),
                                            onTap: _textTittleController
                                                        .text.length ==
                                                    0
                                                ? () {
                                                    final snackBar = SnackBar(
                                                        content: Text(
                                                            "Plx fill the Tittle before "));
                                                    _scaffoldKey.currentState
                                                        .showSnackBar(snackBar);
                                                  }
                                                : () {
                                                    captureImage();
                                                  })),
                              ),
                              Wrap(
                                children: <Widget>[
                                  Text(
                                      'Upload your shop photograph\nto help people\nrecognize you easily',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xFF21BFBD),
                                          fontSize: 15.0))
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ]),
            ),
          )),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('You have unsaved changes'),
            content: new Text('Do you want to go back'),
            actions: <Widget>[
              FlatButton(
                color: Colors.blueAccent[100],
                child: new Text("NO",
                    style: TextStyle(fontSize: 11, color: Colors.white)),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              SizedBox(height: 16),
              FlatButton(
                  color: Colors.blueAccent[100],
                  child: new Text("YES",
                      style: TextStyle(fontSize: 11, color: Colors.white)),
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Inventory()),
                      ModalRoute.withName('/inventory')))
            ],
          ),
        ) ??
        false;
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionFocusNode.dispose();

    _priceFocusNode.dispose();
    _textTittleController.dispose();
  }

  Future<void> captureImage() async {
    dynamic callBackValuesFromImageCap = await Navigator.of(context).pushNamed(
        ImageCaptureForShop.routeName,
        arguments: ScreenArguments(_textTittleController.text, 0));
    setState(() {
      _storedImage = callBackValuesFromImageCap.file;
    });

    final fileName = path.absolute(_storedImage.path);

    _editedproduct = ProductDefinition(
        id: _editedproduct.id,
        tittle: _editedproduct.tittle,
        description: _editedproduct.description,
        price: _editedproduct.price,
        imageUrl: fileName);
  }
}
