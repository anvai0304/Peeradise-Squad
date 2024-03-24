import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/screens/tutors_list_screen.dart';
// import 'TutorsListScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];
  List<String> allSubjects = [];

  // Mapping between subjects and their corresponding icons
  // Map<String, IconData> subjectIcons = {
  //   'maths': Icons.calculate,
  //   'Maths 2': Icons.calculate_outlined,
  //   'Discrete mathematics': Icons.subject,
  //   'chemistry': Icons.science,
  //   'History': Icons.history,
  //   'toc': Icons.qr_code_sharp,
  //   'CA':Icons.cable,
  //   'java': Icons.code,
  //   'JS': Icons.javascript_outlined,
  //   'CN': Icons.network_check,
  //   'OS': Icons.abc,
  //   'Physics': Icons.scale
  //   // Add more subjects and their corresponding icons as needed
  // };

  @override
  void initState() {
    super.initState();
    loadAllSubjectsFromFirestore();
  }

  void loadAllSubjectsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();

      List<String> subjects = [];

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('subjects')) {
          subjects.addAll(List<String>.from(data['subjects']));
        }
      });

      setState(() {
        allSubjects = subjects.toSet().toList();
      });
    } catch (e) {
      print('Error loading subjects: $e');
    }
  }



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String? selectedSubject;
  bool showDropdown = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5), // Set color with opacity
          spreadRadius: 5, // Set spread radius
          blurRadius: 7, // Set blur radius
          offset: Offset(0, 3), // Set offset
        ),
      ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: TextFormField(
            controller: _searchController,
            onChanged: searchSubjects,
            decoration: InputDecoration(
              hintText: 'Search for a subject...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ),
      body:
      Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFADD8E6), // Light Blue with 50% opacity
            Color(0xFF4169E1), // Royal Blue with 30% opacity
          ],
        ),
      ),
        child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Text(
          //     'Recent Searches',
          //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          //   ),
          // ),
          if (showDropdown)
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final subject = searchResults[index];
                  return ListTile(
                    title: Text(subject),
                    onTap: () {
                      setState(() {
                        selectedSubject = subject;
                        showDropdown = false; // Hide search results after selection
                      });
                      navigateToTutorsScreen(subject);
                    },
                  );
                },
              ),
            ),

          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'All Subjects',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            flex: 2,
            child: GridView.count(
              crossAxisCount: 2,
              children: allSubjects.map((subject) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => navigateToTutorsScreen(subject),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(16), // Add padding for button size
                        // textStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold), // Increase font size
                      ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                // subjectIcons[subject],
                                Icons.subject,//Use subject's icon from the map
                                size: 80, // Adjust icon size as needed
                              ),
                              SizedBox(height: 8), // Add spacing between icon and text
                              Text(
                                subject,
                                maxLines: 2, // Set maximum lines to 2
                                overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis (...) if needed
                                textAlign: TextAlign.center, // Center align the text
                                style: TextStyle(
                                  color: Colors.black, // Change text color if needed
                                  fontSize: 20, // Set font size for text
                                ),
                              ),
                            ],
                          ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

        ],
      ),
      ),
    );

  }

  // void searchSubjects(String query) {
  //   setState(() {
  //     searchResults = allSubjects.where((subject) => subject.contains(query)).toList();
  //   });
  // }
  // void searchSubjects(String query) {
  //   setState(() {
  //     searchResults = allSubjects.where((subject) => subject.contains(query)).toList();
  //     showDropdown = query.isNotEmpty; // Show dropdown only when there's input
  //   });
  // }
  void searchSubjects(String query) {
    setState(() {
      searchResults = allSubjects.where((subject) => subject.contains(query)).toList();
      showDropdown = query.isNotEmpty; // Show search results only when there's input
    });
  }

  Future<void> navigateToTutorsScreen(String subject) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TutorsListScreen(subject: subject),
      ),
    );
  }
}