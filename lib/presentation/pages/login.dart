import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/utils/global.dart';
import '../../core/utils/paletas.dart';
import 'home.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

final GoogleSignIn _googleSignIn = GoogleSignIn(
  serverClientId: '469200361363-p7cqp0mvgkmbolpg8fsaa2qni434gid6.apps.googleusercontent.com',);
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
      token = googleAuth.idToken ?? '';

      // 🔹 Crear credenciales
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //  Login en Firebase
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
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kSurface,
        elevation: 0,
        title: const Text('Login', style: TextStyle(color: kTextStrong)),
        iconTheme: const IconThemeData(color: kTextStrong),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: kPrimaryTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_pharmacy_rounded,
                  color: kPrimary,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Farmacias App',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: kTextStrong,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Encuentra tu farmacia y el clima cercano',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: kTextSoft),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.login),
                  label: const Text('Iniciar sesión con Google'),
                  onPressed: () async {
                    user = await signInWithGoogle();

                    if (user != null) {
                      isLogged = true;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error al iniciar sesión'),
                          backgroundColor: kError,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}