import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  FirebaseAuth? _firebaseAuth;

  AuthProvider(){
    _firebaseAuth = FirebaseAuth.instance;
  }

  User? getUser(){
    return _firebaseAuth?.currentUser;
  }

  Future<bool> login(String email, String password) async{
    String errorMessage = "";

    try{
      await _firebaseAuth?.signInWithEmailAndPassword(email: email, password: password);
    } catch(error){
      errorMessage = error.toString();
    }

    if (errorMessage.isNotEmpty){
      return Future.error(errorMessage);
    }

    return true;
  }

  Future<bool> register(String email, String password) async{
    String errorMessage = "";

    try{
      await _firebaseAuth?.createUserWithEmailAndPassword(email: email, password: password);
    } catch(error){
      errorMessage = error.toString();
    }

    if (errorMessage.isNotEmpty){
      return Future.error(errorMessage);
    }

    return true;
  }
}