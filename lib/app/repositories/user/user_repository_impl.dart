// ignore_for_file: non_constant_identifier_names, unused_field, prefer_final_fields, avoid_print, body_might_complete_normally_nullable, empty_statements
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todolist_provider/app/exeption/auth_exeptions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredencial = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredencial.user;
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'email-already-in-use') {
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginTypes.contains('password')) {
          throw AuthExeptions(
              message: 'E-mail já utilizado, por favor escolha outro email');
        } else {
          throw AuthExeptions(
              message:
                  'Voce se Cadastro no Todolist com o google, por favor utilize ele para fazer login');
        }
      } else {
        throw AuthExeptions(message: e.message ?? 'Erro ao Registrar usuário');
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthExeptions(message: e.message ?? 'Erro ao Realizar login');
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        throw AuthExeptions(message: 'login ou senha inválidos');
      }
      throw AuthExeptions(message: e.message ?? 'Erro ao Realizar login');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final loginMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);

      if (loginMethods.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginMethods.contains('google')) {
        throw AuthExeptions(
            message:
                'Cadsatro realizado com o google, não pode ser resetado a senha');
      } else {
        throw AuthExeptions(message: 'e-mail não cadastrado');
      }
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthExeptions(message: 'Erro ao resetar senha');
    }
  }

  @override
  Future<User?> googleLogin() async {
    List<String>? loginMethods;
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn
          .signIn(); // implementacao para abrir a tela do gogole dentro do app
      if (googleUser != null) {
        loginMethods =
            await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);

// Esse if serve para nao sobreescrever os logins do google com o login de email e senha
        if (loginMethods.contains('password')) {
          throw AuthExeptions(
              message:
                  'Você utilizou o email para cadastro, caso tenha esquecido sua senha, clique no link esqueceu sua senha');
        } else {
          final googleAuth = await googleUser.authentication;
          final firebaseCredencial = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          var userCredential =
              await _firebaseAuth.signInWithCredential(firebaseCredencial);
          return userCredential.user;
        }
      }
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      //usar essa logica caso tenham mais de um modo de login alem do google
      if (e.code == 'account-exists-with-different-credential') {
        throw AuthExeptions(message: '''
      Login inválido você se registrou no TodoList com os seguintes provedores:
      ${loginMethods?.join(',')}

''');
      } else {
        throw AuthExeptions(message: 'Erro ao realizar login');
      }
    }
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut();
  }

  @override
  Future<void> updateDisplayName(String name) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      user.reload();
    }
  }
}
