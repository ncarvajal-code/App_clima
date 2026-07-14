import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/utils/global.dart';
import 'home.dart';

import '../../core/utils/global.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    try {
      // 🔹 Seleccionar cuenta Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // usuario canceló
      }

      // 🔹 Obtener autenticación
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 🔹 Crear credenciales
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 🔹 Login en Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print("Error login Google: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text('Iniciar sesión con Google'),
          onPressed: () async {
            user = await signInWithGoogle();

            if (user != null) {
              isLogged = true;
              token = await user?.getIdToken() ?? '';
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomePage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error al iniciar sesión')),
              );
            }
          },
        ),
      ),
    );
  }
}