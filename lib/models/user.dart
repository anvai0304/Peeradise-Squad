import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String username;
  final List<String> subjects;

   const User({
    required this.email,
    required this.uid,
    required this.username,
    required this.subjects,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'uid': uid,
    'email': email,
    'subjects': subjects,
  };

  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      subjects: snapshot['subjects'],
    );
  }
}
class Student {
  final String email;
  final String uid;
  final String username;
  final String Phone;

   const Student({
    required this.email,
    required this.uid,
    required this.username,
    required this.Phone,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'uid': uid,
    'email': email,
    'Phone': Phone,
  };

  static Student fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return Student(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      Phone: snapshot['Phone'],
    );
  }
}
