import 'package:flutter/material.dart';
import 'package:stock_landy/layout/toast.dart';
import 'package:stock_landy/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void handleUnauthorizedError(BuildContext context) async {
  final pref = await SharedPreferences.getInstance();
  pref.setString("token", "");

  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => const Login()),
  );

  showToast(context, "Veuillez vous authentifier");
}
