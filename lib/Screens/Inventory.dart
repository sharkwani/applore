import 'package:demoapplication/Screens/editProduct.dart';
import 'package:demoapplication/Widgets/InventoryWidget.dart';
import 'package:demoapplication/providers/GoogleAuthProvider.dart';
import 'package:demoapplication/providers/Product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum category { LogOut, AddProduct }

class Inventory extends StatefulWidget {
  static const routeName = '/inventory';
  Inventory({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  int page = 1;
  List<ProductDefinition> items = null;
  bool isLoading = false;

  Future _loadData() async {
    // perform fetching data delay
    await new Future.delayed(new Duration(seconds: 2));

    print("load more");
    // update data and loading status
    ProductDefinition productObj = ProductDefinition();

    final user = FirebaseAuth.instance.currentUser;
    dynamic token = await user.getIdToken(true);
    var _items = await productObj.getProductFromFirebase(user.uid, token);
    setState(() {
      items = _items;
      print(_items);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory"),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (category category_value) async {
                if (category_value == category.LogOut) {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                }
                if (category_value == category.AddProduct) {
                  Navigator.pushNamed(context, AddProductNormally.routeName);
                }
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Log Out"),
                      value: category.LogOut,
                    ),
                    PopupMenuItem(
                      child: Text("Add Product "),
                      value: category.AddProduct,
                    ),
                  ]),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!isLoading &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    _loadData();
                    // start loading data
                    setState(() {
                      isLoading = true;
                    });
                  }
                },
                child: items == null
                    ? Container(
                        height: 50,
                        color: Colors.transparent,
                        child: Center(
                          child: new CircularProgressIndicator(),
                        ),
                      )
                    : items.length != 0
                        ? ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return InventoryWidget(
                                productName: items[index].tittle,
                                description: items[index].description,
                                price: items[index].price,
                                imagePath: items[index].imageUrl,
                              );
                            },
                          )
                        : Container(
                            child: Center(
                              child:
                                  Text(" Nothing addded yet in product list"),
                            ),
                          )),
          ),
          Container(
            height: isLoading ? 50.0 : 0,
            color: Colors.transparent,
            child: Center(
              child: new CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _loadData();
  }
}
