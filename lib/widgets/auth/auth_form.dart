import 'dart:io';
import 'package:chat_app/widgets/pickers/user_image.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    File? image,
    bool isLogin,
  ) submitForm;
  final bool isLoading;

  const AuthForm({Key? key, required this.submitForm, required this.isLoading})
      : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File? _userImage;

  void _pickImage(File image) {
    _userImage = image;
  }

  void _trySubmit() {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate();
    if (!_isLogin && _userImage == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please pick an image!'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid != null && isValid) {
      _formKey.currentState?.save();
      widget.submitForm(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImage == null ? null : _userImage as File,
        _isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                if (!_isLogin) UserImagePicker(pickImage: _pickImage),
                TextFormField(
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter valid email address.';
                    }
                    return null;
                  },
                  onSaved: (value) => _userEmail = value as String,
                ),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('username'),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username must be 4 characters long.';
                      }
                      return null;
                    },
                    onSaved: (value) => _userName = value as String,
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 4) {
                      return 'Password must be at least 4 characters long.';
                    }
                    return null;
                  },
                  onSaved: (value) => _userPassword = value as String,
                ),
                const SizedBox(height: 12),
                if (widget.isLoading) const CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                    onPressed: _trySubmit,
                    child: Text(_isLogin ? 'Login' : 'Signup'),
                  ),
                if (!widget.isLoading)
                  TextButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    child: Text(_isLogin
                        ? 'Create New Account'
                        : 'I already have an account'),
                  )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
