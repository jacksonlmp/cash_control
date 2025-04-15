import 'package:flutter/material.dart';

AppBar buildAppBar(context, title, route){
  return AppBar(
    title: Text(
      title,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.black,
    shape: const Border(
      bottom: BorderSide(color: Colors.white, width: 1.5),
    ),
    leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () =>
            Navigator.pushReplacementNamed(context, route)
    ),
  );
}