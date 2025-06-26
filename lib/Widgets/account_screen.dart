import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trading/Model/user_model.dart'; 

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  UserModel? _userModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      final doc = await _firestore.collection('users').doc(_user!.uid).get();
      if (doc.exists) {
        _userModel = UserModel.fromMap(doc.data()!);
        _usernameController.text = _userModel?.username ?? '';
        _phoneController.text = _userModel?.phone ?? '';
        _countryController.text = _userModel?.country ?? '';
      } else {
        // Crée un profil vide si inexistant
        _userModel = UserModel(
          uid: _user!.uid,
          email: _user!.email!,
          username: '',
          phone: '',
          country: '',
        );
        await _firestore
            .collection('users')
            .doc(_user!.uid)
            .set(_userModel!.toMap());
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      final updatedModel = UserModel(
        uid: _user!.uid,
        email: _user!.email!,
        username: _usernameController.text.trim(),
        phone: _phoneController.text.trim(),
        country: _countryController.text.trim(),
      );

      await _firestore
          .collection('users')
          .doc(_user!.uid)
          .set(updatedModel.toMap(), SetOptions(merge: true));

      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informations updated')),
        );
      }
    }
  }

  Future<void> _changePassword() async {
    if (_user != null) {
      await _auth.sendPasswordResetEmail(email: _user!.email!);
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reset email sent')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My account'),
        backgroundColor: const Color.fromARGB(255, 9, 126, 126),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your username' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _user?.email,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _saveUserData,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 9, 126, 126),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _changePassword,
                icon: const Icon(Icons.lock_reset),
                label: const Text('Modify the password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
