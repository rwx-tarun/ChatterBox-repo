import 'package:chat_app/misc/constant.dart';
import 'package:flutter/material.dart';

InputDecoration textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Constant.primaryColor,
      width: 2,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Constant.primaryColor,
      width: 2,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Constant.primaryColor,
      width: 2,
    ),
  ),
);

InputDecoration textInputDecoration1 = InputDecoration(
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Constant.primaryColor,
      width: 2,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Constant.primaryColor,
      width: 2,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Constant.primaryColor,
      width: 2,
    ),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Constant.primaryColor,
      width: 2,
    ),
  ),
  border: UnderlineInputBorder(),
);
