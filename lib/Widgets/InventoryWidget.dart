import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InventoryWidget extends StatefulWidget {
  final String productName;
  final String description;
  final String imagePath;
  final double price;

  const InventoryWidget(
      {this.productName, this.description, this.imagePath, this.price});
  @override
  _InventoryWidgetState createState() => _InventoryWidgetState();
}

class _InventoryWidgetState extends State<InventoryWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(widget.productName),
        subtitle: Text(widget.description),
        leading:
            CircleAvatar(backgroundImage: FileImage(File(widget.imagePath))),
        trailing: Text(" \u{20B9}  ${widget.price}"));
  }
}
