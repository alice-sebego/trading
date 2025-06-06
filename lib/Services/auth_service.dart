import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Inscription
  Future<void> signUp(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null) {
      // Enregistrement dans la collection users
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Connexion
  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Stream d’état d’authentification
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // Récupérer l’utilisateur actuel
  User? get currentUser => _auth.currentUser;
}
