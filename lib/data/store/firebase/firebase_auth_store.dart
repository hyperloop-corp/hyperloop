import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hyperloop/core/errors/exceptions.dart';
import 'package:hyperloop/data/models/user_model.dart';
import 'package:hyperloop/data/store/auth_store.dart';
import 'package:hyperloop/data/store/firebase/firebase_store.dart';
import 'package:hyperloop/domain/entities/phone_auth_state.dart';

class FirebaseAuthStore extends FirebaseStore implements AuthStore {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  StreamController<PhoneAuthState> _phoneAuthState;
  String _verificationId;

  FirebaseAuthStore({@required this.firebaseAuth, @required this.googleSignIn});

  @override
  Future<void> forgotPassword(String email) async {
    // TODO: implement forgotPassword
    try {
      return null;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Stream<UserModel> onAuthStateChanged() {
    return firebaseAuth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  @override
  Future<UserModel> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      AuthResult authResult = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      print('Email: ' + email + ' Password: ' + password);
      AuthResult authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebaseUser(authResult.user);
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Stream<PhoneAuthState> verifyPhoneNumber(String phoneNumber) {
    _phoneAuthState?.close();
    _phoneAuthState = StreamController(sync: true);

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authCredential) {
      print('Auto retrieving verification code');

      firebaseAuth
          .signInWithCredential(authCredential)
          .then((AuthResult value) {
        if (value.user != null) {
          print('Authentication successful');
          _phoneAuthState.sink.add(PhoneAuthState.Verified);
        } else {
          print('Invalid code/invalid authentication');
          _phoneAuthState.sink.add(PhoneAuthState.Failed);
        }
      }).catchError((error) {
        print('Something has gone wrong, please try later $error');
        _phoneAuthState.sink.add(PhoneAuthState.Error);
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print(authException.message);

      print(authException.toString());
      _phoneAuthState.sink.add(PhoneAuthState.Error);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      _phoneAuthState.sink.add(PhoneAuthState.CodeSent);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      _phoneAuthState.sink.add(PhoneAuthState.AutoRetrievalTimeOut);
    };

    try {
      firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: Duration(seconds: 60),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch(e) {
      print(e);
      throw ServerException();
    }

    return _phoneAuthState.stream;
  }

  @override
  Future<UserModel> signInWithPhoneNumber(String smsCode) async {
    final authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: smsCode);

    AuthResult authResult =
        await firebaseAuth.signInWithCredential(authCredential);
    return _userFromFirebaseUser(authResult.user);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    print('AuthCredential: ' + authCredential.toString());

    AuthResult authResult =
        await firebaseAuth.signInWithCredential(authCredential);
    print('UID: ' + authResult.user.uid);
    return _userFromFirebaseUser(authResult.user);
  }

  @override
  Future<void> signOut() async {
    try {
      return await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> get user async =>
      _userFromFirebaseUser(await firebaseAuth.currentUser());

  UserModel _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }
}
