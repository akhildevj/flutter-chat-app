import 'dart:io';

import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitForm(
    String email,
    String password,
    String username,
    File? image,
    bool isLogin,
  ) async {
    UserCredential userCredential;

    try {
      setState(() => _isLoading = true);
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ChatScreen()));
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${userCredential.user?.uid}.jpg');
        await ref.putFile(image as File);
        final url = await ref.getDownloadURL();

        final userData = {
          'username': username,
          'email': email,
          'image_url': url
        };
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set(userData);
      }
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.message ?? 'An  error occured!'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() => _isLoading = false);
    } catch (err) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(submitForm: _submitForm, isLoading: _isLoading),
    );
  }
}
