import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/utilis/colors.dart';
import 'package:instagram_flutter/utilis/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;
  int notificationCount = 0; // Variable to store notification count

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    // Call function to fetch notification count when screen initializes
    fetchNotificationCount();
  }

  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
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
      body: PageView(
        children: homeScreenItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _page == 0 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            // Use a Stack to overlay a badge widget on top of the notifications icon
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications_on_rounded,
                  color: _page == 1 ? primaryColor : secondaryColor,
                ),
                // Badge widget for notification count
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red, // Color of the badge
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      notificationCount.toString(), // Display the actual notification count
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white, // Color of the count text
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 2 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
