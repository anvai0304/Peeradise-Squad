import "package:flutter/material.dart";
import "package:instagram_flutter/resources/auth_methods.dart";
import "package:instagram_flutter/responsive/mobile_screen_layout.dart";
import "package:instagram_flutter/responsive/responsive_layout_screen.dart";
import "package:instagram_flutter/responsive/web_screen_layout.dart";
import "package:instagram_flutter/utilis/colors.dart";
import "package:instagram_flutter/utilis/utilis.dart";
import "package:instagram_flutter/widgets/text_field_input.dart";

class RegisterTutor extends StatefulWidget {
  const RegisterTutor({Key? key}) : super(key: key);

  @override
  State<RegisterTutor> createState() => _RegisterTutorState();
}

class _RegisterTutorState extends State<RegisterTutor> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final List<TextEditingController> _subjectControllers = [
    TextEditingController()
  ];
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _subjectControllers.forEach((controller) => controller.dispose());
  }

  void registerTutor() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String username = _usernameController.text.trim();
    List<String> subjects = _subjectControllers
        .map((controller) => controller.text.trim())
        .toList();

    // Check for empty fields
    if (email.isEmpty ||
        password.isEmpty ||
        username.isEmpty ||
        subjects.any((subject) => subject.isEmpty)) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(
                "Please enter all fields"),
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
      return;
    }

    // Check if the email format is valid
    if (!isValidEmail(email)) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, 'Please enter a valid email address');
      return;
    }

    // Check if the email ends with "@walchandsangli.ac.in"
    if (!email.endsWith("@walchandsangli.ac.in")) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Email"),
            content: Text(
                "Registration is only allowed for college emails."),
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
      return;
    }

    // Continue with the registration process
    String res = await AuthMethods().registerTutor(
      email: email,
      password: password,
      username: username,
      subjects: subjects,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: webScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
  }

  // Method to validate email format
  bool isValidEmail(String email) {
    // Email regex pattern
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height, // Set a fixed height
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE91E63), // Pink
                Color(0xFF9C27B0), // Purple
                Colors.purpleAccent, // White
                Color(0xFF9C27B0), // Purple
                Color(0xFFE91E63), // Pink
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 30,
                          ),
                          child: Text(
                            "TUTOR REGISTRATION",
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 5.0,
                                  color: Colors.black,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextFieldInput(
                      hintText: 'Enter your username',
                      textInputType: TextInputType.text,
                      textEditingController: _usernameController,
                    ),
                    const SizedBox(height: 24),
                    TextFieldInput(
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress,
                      textEditingController: _emailController,
                    ),
                    const SizedBox(height: 24),
                    TextFieldInput(
                      hintText: 'Enter your password',
                      textInputType: TextInputType.text,
                      textEditingController: _passwordController,
                      isPass: true,
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NOTE:Enter the full name of the subject in lowercase:',
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Column(
                          children: _subjectControllers.map((controller) {
                            controller.addListener(() {
                              final text = controller.text.toLowerCase();
                              final selection = controller.selection;
                              controller.value = controller.value.copyWith(
                                text: text,
                                selection: TextSelection.collapsed(
                                    offset: selection.extentOffset),
                              );
                            });
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TextFieldInput(
                                hintText: 'Enter subject',
                                textInputType: TextInputType.text,
                                textEditingController: controller,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _subjectControllers.add(TextEditingController());
                        });
                      },
                      child: Text('Add Subject'),
                    ),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: registerTutor,
                      child: Container(
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                            : const Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.purpleAccent, width: 1),
                          borderRadius: BorderRadius.circular(
                              15), // Border radius for the button
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
              Flexible(child: Container(), flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}