import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/user_details.dart';

class LoginController with ChangeNotifier {
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  UserDetails? userDetails;
  googleLogin() async {
    googleSignInAccount = await _googleSignIn.signIn();
    userDetails = UserDetails(
      name: googleSignInAccount!.displayName,
      email: googleSignInAccount!.email,
      image: googleSignInAccount!.photoUrl,
    );
    notifyListeners();
  }
}