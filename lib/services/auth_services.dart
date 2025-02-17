import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthServices{
  AuthServices._();
  // single tone object
  static AuthServices authServices = AuthServices._();


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // sign up with email pass
  Future<bool> signUpWithEmailPass(String email, password) async {
    try{
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if(credential.user != null){
        return true;
      } else {
        return false;
      }
    } catch(e){
      log(e.toString());
    }

    return false;
  }


  // sign in with email pass
  Future<bool> signInWithEmailPass(String email, password) async {
    try{
      final credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if(credential.user != null){
        return true;
      } else {
        return false;
      }
    } catch(e){
      log(e.toString());
    }

    return false;
  }

  // get current user
  User? getCurrentUser(){
    return _firebaseAuth.currentUser;
  }

  // sign out
  Future<bool> signOut() async {
    await _firebaseAuth.signOut();
    if(getCurrentUser() == null){
      return true;
    } else {
      return false;
    }
  }
}