import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailForm extends StatefulWidget {
  const EmailForm({Key? key}) : super(key: key);

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _venueController;
  late TextEditingController _timeSlotController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _venueController = TextEditingController();
    _timeSlotController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _venueController.dispose();
    _timeSlotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Email'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Student Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the student\'s email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _venueController,
                decoration: InputDecoration(labelText: 'Venue'),
              ),
              TextFormField(
                controller: _timeSlotController,
                decoration: InputDecoration(labelText: 'Time Slot'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    sendEmail();
                  }
                },
                child: Text('Send Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendEmail() async {
    final String studentEmail = _emailController.text;
    final String venue = _venueController.text;
    final String timeSlot = _timeSlotController.text;

    final smtpServer = gmail('anujasuntnur@gmail.com', 'Anusunt@2004');

    final message = Message()
      ..from = Address('anujasuntnur@gmail.com', 'Anuja Suntnur')
      ..recipients.add(studentEmail)
      ..subject = 'Invitation Accepted'
      ..text = 'Dear student,\n\n'
          'I have accepted your invitation. The details are as follows:\n\n'
          'Venue: $venue\n'
          'Time Slot: $timeSlot\n\n'
          'Looking forward to meeting you!\n\n'
          'Sincerely,\n'
          'Tutor';

    try {
      await send(message, smtpServer);
      // Email sent successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email sent successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Error sending email
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending email: $e'),
        ),
      );
    }
  }
}

