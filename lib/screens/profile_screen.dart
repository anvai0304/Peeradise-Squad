import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/utilis/utilis.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      var snap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
      if (snap.exists) {
        userData = snap.data()!;
      } else {
        showSnackBar(
          context,
          'User data not found',
        );
      }
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadProfilePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Set the state to indicate that the screen is loading
      setState(() {
        _isLoading = true;
      });

      // Create a reference to the location where the image will be stored in Firebase Storage
      final Reference ref = FirebaseStorage.instance.ref().child('profile_photos').child(widget.uid);

      // Upload the image file to Firebase Storage
      await ref.putFile(File(pickedFile.path));

      // Get the download URL of the uploaded image
      final String imageUrl = await ref.getDownloadURL();

      // Update the user's profile data in Firestore with the image URL
      await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
        'profile_photo': imageUrl,
      });

      // Fetch the updated user data from Firestore
      await getData();

      // Set the state to indicate that the screen has finished loading
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login screen or any other screen after sign-out
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 1.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: 150, // Adjust the position as needed
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : userData.isEmpty
                      ? Text('No user data available')
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(userData['profile_photo'] ?? 'https://via.placeholder.com/150'),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _uploadProfilePhoto,
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30), // Space for profile image
                            Text(
                              userData['username'] ?? 'Username',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 30),
                            Text(
                              'Email: ${userData['email']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 30),
                            Text(
                              userData['Phone'] ?? userData['subjects'].join(', '),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _signOut,
                              child: Text('Sign Out'),
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
