
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:string_validator/string_validator.dart';

enum Status { Authenticated, Authenticating, Unauthenticated }


class UserNotifier extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  Status _status = Status.Unauthenticated;
  User? _user;
  CircleAvatar _userImage = CircleAvatar(radius: 30, backgroundColor: Colors.brown.shade800);
  Widget _data = Container();

  UserNotifier() {
    _auth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser == null) {
        _user = null;
        _status = Status.Unauthenticated;
      } else {
        _user = firebaseUser;
        _status = Status.Authenticated;
      }
      notifyListeners();
    });
  }

  Status get status => _status;

  set status(Status value) {
    _status = value;
    notifyListeners();
  }
  Widget get data => _data;

  set data(Widget value) {
    _data = value;
    notifyListeners();
  }


  CircleAvatar get userImage => _userImage;

  String? getEmail() {
    return _user?.email;
  }
  String? getID() {
    return _auth.currentUser?.uid;
  }

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      _status = Status.Authenticating;
      var newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      addUser(newUser.user?.uid);
      String name = (email.length > 1 && isAlpha(email[1]))? email[0].toUpperCase() + email[1].toUpperCase() : email[0].toUpperCase();
      _userImage =  CircleAvatar(radius: 30, backgroundColor: Colors.brown.shade800,child: Text(name ,style: const TextStyle(fontSize: 30),),);
      return newUser;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      try {
         notifyListeners();
        var url = await downloadFile();
         _userImage = CircleAvatar(
             radius: 35,
             backgroundColor: Colors.blue,
             child: CircleAvatar(
               radius: 32,
               backgroundColor: Colors.white,
               child: CircleAvatar(
                 radius: 29,
                 backgroundImage: NetworkImage(url),
               ),
             ),
         );


      }catch(e)
      {
        String name = (email.length > 1 && isAlpha(email[1]))? email[0].toUpperCase() + email[1].toUpperCase() : email[0].toUpperCase();
        _userImage =  CircleAvatar(radius: 30, backgroundColor: Colors.brown.shade800,child: Text(name ,style: const TextStyle(fontSize: 30),),);
      }
      notifyListeners();
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  void signOut() {
    _auth.signOut();
    _user = null;
    _status = Status.Unauthenticated;
    notifyListeners();
  }

  Future<void> addUser(String? id) async {
    final store = FirebaseFirestore.instance;
    store.collection('users').doc(id).set({});
  }

  Future<String> downloadFile() {
    return _storage
        .ref('avatars')
        .child(_user?.uid ?? 'default')
        .getDownloadURL();
  }

  Future<void> uploadFile(String localPath) async {
    try {
      await _storage.ref('avatars').child(_user?.uid ?? 'default').putFile(File(localPath));
    }
    catch (e) { }
  }
  Future<void> changeAvatar(String localPath) async {
      notifyListeners();
      uploadFile(localPath);
      _userImage = CircleAvatar(
        radius: 35,
        backgroundColor: Colors.blue,
        child: CircleAvatar(
          radius: 32,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 29,
            backgroundImage: Image.file(File(localPath)).image),
          ),
      );
      notifyListeners();
  }

}
