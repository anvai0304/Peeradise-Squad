import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for launching URLs

class StudentProfileScreen extends StatefulWidget {
  final String uid;

  const StudentProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  Map<String, dynamic> userData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
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

  Future<void> sendEmailToTutor() async {
    // Define email content (venue and time slot)
    String venue = "Your venue here";
    String timeSlot = "Your time slot here";

    // Concatenate email message
    String emailMessage = "Hello, \n\nHere are the details for our tutoring session:\n\n"
        "Venue: $venue\n"
        "Time Slot: $timeSlot\n\n"
        "Looking forward to it!\n\n"
        "Sincerely,\n"
        "${userData['username']}";

    //  String encodedMessage = Uri.encodeQueryComponent(emailMessage);



    // Compose email URL with subject and body
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: userData['email'], // Tutor's email address
      queryParameters: {
        'subject': 'Tutoring Session Details',
        'body': emailMessage,
      },
    );

    // Launch email client with pre-filled email
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not launch email';
    }
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Student Profile'),
//       ),
//       body: _isLoading
//           ? Center(
//         child: CircularProgressIndicator(),
//       )
//           : SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: NetworkImage(userData['profileImageUrl'] ?? ''),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Username: ${userData['username']}',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Email: ${userData['email']}',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 sendEmailToTutor();
//               },
//               child: Text('Send Email to Student'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
            Text(
              userData['Phone'] ?? userData['subjects'].join(', '),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,

              ),
            ),
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.8, // Adjust the width as needed
            //   child: Card(
            //     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            //     clipBehavior: Clip.antiAlias,
            //     color: Colors.white,
            //     elevation: 5,
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 22),
            //       child: Row(
            //         children: <Widget>[
            //           Expanded(
            //             child: Column(
            //               children: <Widget>[
            //                 Text(
            //                   'Subjects: ${userData['subjects'].join(', ')}',
            //                   style: TextStyle(fontSize: 16),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            SizedBox(height: 20),

            Container(
              width: MediaQuery.of(context).size.width * 0.7, // Adjust the width as needed
              child: SizedBox(
                height: 50,
                width: double.infinity, // Make the SizedBox expand to fill the available width
                child: ElevatedButton(
                onPressed: () {
                sendEmailToTutor();
                },
                  style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Change button color to green
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                        shadowColor: Colors.black,
                      ),
                child: Text('Send Email to Student'),
                ),
                // ElevatedButton(
                //   onPressed: _requestSent ? null : sendRequest, // Disable button if request has been sent
                //
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.green, // Change button color to green
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     elevation: 5,
                //     shadowColor: Colors.black,
                //   ),
                //   child: Text(_requestSent ? 'Requested' : 'Send Request'), // Change button text based on request status
                // ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}