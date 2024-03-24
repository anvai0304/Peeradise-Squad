import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TutorProfileScreen extends StatefulWidget {
  final String uid;

  const TutorProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _TutorProfileScreenState createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  Map<String, dynamic> userData = {};
  bool _isLoading = true;
  bool _requestSent = false; // Track whether the request has been sent

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data() as Map<String, dynamic>;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User data not found'),
        ));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching user data: $e'),
      ));
    }
  }

  Future<void> sendRequest() async {
    try {
  // Create a request document in Firestore
  await FirebaseFirestore.instance.collection('requests').add({
    'senderId': FirebaseAuth.instance.currentUser!.uid,
    'receiverId': widget.uid,
    'timestamp': Timestamp.now(),
    // Add more details as needed
  });

  // Update state to reflect that request has been sent
  setState(() {
    _requestSent = true;
  });

  // Show success message
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Success"),
        content: Text("Request sent successfully"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
} catch (e) {
  // Handle error
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Error"),
        content: Text("Error sending request: $e"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 10),
                        ),
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('https://via.placeholder.com/150'),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        color: Colors.green,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Username: ${userData['username']}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${userData['email']}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width *
                  0.8, // Adjust the width as needed
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                elevation: 5,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 22),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Subjects: ${userData['subjects'].join(', ')}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Card(
            // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            // clipBehavior: Clip.antiAlias,
            // color: Colors.white,
            // elevation: 5,
            // child: Padding(
            // padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            // child: Row(
            // children: <Widget>[
            // Expanded(
            // child: Column(
            // children: <Widget>[
            //   Text(
            //               'Subjects: ${userData['subjects'].join(', ')}',
            //               style: TextStyle(fontSize: 16),
            //             ),
            // ],
            // ),
            // ),
            // ],
            // ),
            // ),
            // ),
            SizedBox(height: 20),

            Container(
              width: MediaQuery.of(context).size.width *
                  0.7, // Adjust the width as needed
              child: SizedBox(
                height: 50,
                width: double
                    .infinity, // Make the SizedBox expand to fill the available width
                child: ElevatedButton(
                  onPressed: _requestSent
                      ? null
                      : sendRequest, // Disable button if request has been sent

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, // Change button color to green
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black,
                  ),
                  child: Text(_requestSent
                      ? 'Requested'
                      : 'Send Request'), // Change button text based on request status
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
