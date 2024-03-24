import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tutor_profile_screen.dart';

class TutorsListScreen extends StatefulWidget {
  final String subject;

  const TutorsListScreen({Key? key, required this.subject}) : super(key: key);

  @override
  _TutorsListScreenState createState() => _TutorsListScreenState();
}

class _TutorsListScreenState extends State<TutorsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutors for ${widget.subject}'),
        backgroundColor: Colors.deepPurple.withOpacity(0.7),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('subjects', arrayContains: widget.subject)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final tutorData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Card(
                  margin: EdgeInsets.all(8),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(tutorData['photoUrl'] ?? 'https://via.placeholder.com/150'),
                    ),
                    title: Text(tutorData['username'] ?? ''),
                    subtitle: Text(tutorData['bio'] ?? ''),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TutorProfileScreen(
                            uid: tutorData['uid'] ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No tutors found for ${widget.subject}'),
            );
          }
        },
      ),
    );
  }
}