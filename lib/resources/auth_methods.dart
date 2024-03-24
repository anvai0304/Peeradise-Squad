import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:instagram_flutter/models/student.dart' as student_model;
import 'package:instagram_flutter/models/user.dart' as user_model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<user_model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('user').doc(newMethod(currentUser).uid).get();

    return user_model.User.fromSnap(snap);
  }

  User newMethod(User currentUser) => currentUser;

  // Register student
  Future<String> registerStudent({
    required String email,
    required String password,
    required String username,
    required String Phone,
    // required List<String> notifications,
  }) async {
    String res = "some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || Phone.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        user_model.Student student = user_model.Student(
          email: email,
          uid: cred.user!.uid,
          username: username,
          Phone: Phone,
          // notifications: notifications,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(student.toJson());

        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'the email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'Password should be at least 6 characters.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Register tutor
  Future<String> registerTutor({
    required String email,
    required String password,
    required String username,
     required List<String> subjects,
    //  required List<String> notifications,
  }) async {
    String res = "some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || subjects.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        user_model.User user = user_model.User(
          email: email,
          uid: cred.user!.uid,
          username: username,
          subjects: subjects,
          // notifications: notifications,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'the email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'Password should be at least 6 characters.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Logging in user
  Future<String> SignIn({
    required String email,
    required String password,
  }) async {
    String res = "some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  Future<void> sendNotification({
  required String senderId,
  required String receiverId,
  required String message,
}) async {
  try {
    await FirebaseFirestore.instance.collection('notifications').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(), // Automatically generate timestamp
    });
    print('Notification sent successfully');
  } catch (e) {
    print('Error sending notification: $e');
  }
}
}

