import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/screens/student_profile_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Stream<QuerySnapshot> _notificationsStream;
  int notificationCount = 0; // Define notificationCount here

  @override
  void initState() {
    super.initState();
    // Initialize the stream to listen for notifications
    _notificationsStream = FirebaseFirestore.instance
        .collection('requests')
        .where('receiverId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots(); // Adjust the Firestore collection and query as needed

    // Call function to fetch notification count when screen initializes
    fetchNotificationCount();
  }

  // Function to fetch notification count from Firestore
  Future<void> fetchNotificationCount() async {
    try {
      // Query Firestore to get count of unread notifications for current user
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('recipientId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('read', isEqualTo: false)
          .get();

      // Update notification count with count of unread notifications
      setState(() {
        notificationCount = querySnapshot.size;
      });
    } catch (e) {
      print('Error fetching notification count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _notificationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final notifications = snapshot.data!.docs;
            if (notifications.isEmpty) {
              return Center(
                child: Text('No notifications found.'),
              );
            }
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final notificationData = notification.data() as Map<String, dynamic>?;

                if (notificationData != null) {
                  final senderId = notificationData['senderId'] as String?;
                  // Prevent tutor from sending request to himself
                  if (senderId == FirebaseAuth.instance.currentUser!.uid) {
                    return SizedBox();
                  }

                  // Fetch the user document for the sender
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(senderId).get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return ListTile(
                          title: Text('Loading...'),
                        );
                      } else if (userSnapshot.hasError) {
                        return ListTile(
                          title: Text('Error: ${userSnapshot.error}'),
                        );
                      } else if (userSnapshot.hasData) {
                        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                        final senderUsername = userData['username'] as String?;
                        final isAccepted = notificationData['isAccepted'] as bool? ?? false;
                        // Build UI for notification with sender's username
                        if (senderId != null) {
                          return ListTile(
                            title: Text('Notification from: $senderUsername'),
                            trailing: isAccepted
                                ? Text('Accepted')
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          // Accept notification: Open student profile
                                          await FirebaseFirestore.instance.collection('requests').doc(notification.id).update({
                                            'isAccepted': true,
                                          });

                                          // Notify the student that the tutor accepted their request
                                          final studentId = notificationData['receiverId'];
                                          final tutorUsername = FirebaseAuth.instance.currentUser!.displayName;
                                          await FirebaseFirestore.instance.collection('notifications').add({
                                            'recipientId': studentId,
                                            'message': '$tutorUsername accepted your request.',
                                            'timestamp': Timestamp.now(),
                                          });
                                          // Update UI after accepting the request
                                          setState(() {
                                            notificationData['isAccepted'] = true;
                                          });
                                        },
                                        child: Text('Accept'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Decline notification: Delete the notification
                                          FirebaseFirestore.instance.collection('requests').doc(notification.id).delete();
                                          // Optionally update UI after declining the request
                                          setState(() {
                                            notifications.removeAt(index);
                                          });
                                        },
                                        child: Text('Decline'),
                                      ),
                                    ],
                                  ),
                            onTap: isAccepted
                                ? () {
                                    // Open student profile
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StudentProfileScreen(uid: senderId),
                                      ),
                                    );
                                  }
                                : null,
                          );
                        } else {
                          return ListTile(
                            title: Text('No user data found.'),
                          );
                        }
                      } else {
                        return SizedBox();
                      }
                    },
                  );
                } else {
                  // Handle case where notificationData is null or required fields are missing
                  return SizedBox();
                }
              },
            );
          } else {
            return Center(
              child: Text('No notifications found.'),
            );
          }
        },
      ),
    );
  }
}
