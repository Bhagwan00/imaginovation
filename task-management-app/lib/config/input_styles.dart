import 'package:flutter/material.dart';

import 'colors.dart';

InputDecoration kInputStyle = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  labelStyle: const TextStyle(fontSize: 16, color: kSecondaryColor),
  contentPadding: const EdgeInsets.only(left: 14.0, bottom: 4.0, top: 4.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(),
    borderRadius: BorderRadius.circular(10.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(),
    borderRadius: BorderRadius.circular(10.0),
  ),
);

InputDecoration kInputSecondaryStyle = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  labelStyle: const TextStyle(fontSize: 16, color: kWhiteColor),
  contentPadding: const EdgeInsets.only(left: 14.0, bottom: 4.0, top: 4.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
);
