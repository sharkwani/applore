import 'package:demoapplication/Screens/editProduct.dart';
import 'package:demoapplication/providers/GoogleAuthProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final bool whatToShow;
  static final navigatorKey = new GlobalKey<NavigatorState>();
  const AppDrawer(this.whatToShow);
  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;
    final String emailAddress = user.email;
    final String displayName = user.displayName;
    final String profilePic = user.photoURL;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context, emailAddress, displayName, profilePic),
          _createDrawerItem(
              icon: Icons.event,
              text: 'Add Products',
              onTap: () {
                // await oderData.getOrdersFirebase();
             Navigator.pushNamed(
                  context,
                  AddProductNormally.routeName
                );
                //arguments: oderData);
              }),
          Divider(),
          _createDrawerItem(
              icon: Icons.exit_to_app,
              text: 'Log Out',
              onTap: () {
                final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              }),
          ListTile(
            title: Text('0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader(context, emailAddress, displayName, profilePic) {
    print(profilePic);
    print(emailAddress);
    print(displayName);
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(color: Colors.white),
        child: LayoutBuilder(
            builder: (context, constraints) =>
                Stack(textDirection: TextDirection.ltr, children: <Widget>[
                  Positioned(
                    top: 20,
                    left: constraints.maxWidth / 2 + 20,
                    child: profilePic != null
                        ? Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(profilePic))))
                        : emailAddress != null
                        ? LayoutBuilder(
                        builder: (context, constraints) =>
                            Stack(children: <Widget>[
                              Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/nothing.jpg"))),
                              ),
                            ]))
                        : Container(
                      width: 100.0,
                      height: 100.0,
                    ),
                  ),
                  Positioned(
                      bottom: 40.0,
                      left: 16.0,
                      child: Text(displayName == null ? " " : displayName,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500))),
                  Positioned(
                      bottom: 12.0,
                      left: 16.0,
                      child: Text(
                          emailAddress != null ? emailAddress : " Welcome",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300))),
                ])));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
