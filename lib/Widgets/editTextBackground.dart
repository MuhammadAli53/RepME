import 'package:flutter/material.dart';

const editTextDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.grey),

  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff131212), width: 0.5),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff131212), width: 0.5),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
);
