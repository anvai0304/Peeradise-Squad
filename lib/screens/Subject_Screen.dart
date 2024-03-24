import 'package:flutter/material.dart';

class SubjectsScreen extends StatelessWidget {
  final List<String> subjects;
  final Function(String) onTapSubject;

  SubjectsScreen({required this.subjects, required this.onTapSubject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects'),
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(subjects[index]),
            onTap: () => onTapSubject(subjects[index]),
          );
        },
      ),
    );
  }
}
