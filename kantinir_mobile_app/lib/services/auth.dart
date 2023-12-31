import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kantinir_mobile_app/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create a stream
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  //auth change stream
  Stream<MyUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String username ,String password, String fcolor, String bday, String education,Function(String)? errorCallback) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      FirebaseFirestore.instance
        .collection("Users")
        .doc(result.user!.email)
        .set({
          'username' :username,  // initial user
          'birthdate':bday,
          'education':education,
          'fcolor'   :fcolor,
            //add more fields
          });

    } catch (e) {
      print(e.toString());
      if (errorCallback != null) {
      errorCallback(e.toString());
      }
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
