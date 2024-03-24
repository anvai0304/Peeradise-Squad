import "dart:typed_data";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
// import "package:flutter_svg/flutter_svg.dart";
// import "package:image_picker/image_picker.dart";
import "package:instagram_flutter/resources/auth_methods.dart";
import "package:instagram_flutter/responsive/mobile_screen_layout.dart";
import "package:instagram_flutter/responsive/responsive_layout_screen.dart";
import "package:instagram_flutter/responsive/web_screen_layout.dart";
import "package:instagram_flutter/screens/login_screen.dart";
import "package:instagram_flutter/utilis/colors.dart";
import "package:instagram_flutter/utilis/utilis.dart";
import "package:instagram_flutter/widgets/text_field_input.dart";

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  // Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  
  void signin() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().SignIn(
      email: _emailController.text,
      password: _passwordController.text,
      // username: _usernameController.text,
      // bio: _bioController.text,
      // file: _image!,
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
              mobileScreenLayout: MobileScreenLayout()),
        ),
      );
    }
  }

  // void navigateToLogin() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => LoginScreen(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,

          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7EA6E0),
                Color(0xFF4D7DBA),
                Color(0xFF1E4A7F).withOpacity(0.7),
                Color(0xFF7EA6E0).withOpacity(0.5),
                Color(0xFF7EA6E0), // Light Blue
                Color(0xFF4D7DBA), // Medium Blue
                Color(0xFF1E4A7F), // Dark Blue
              ],
            ),
          ),


          child: Container(

            // decoration: BoxDecoration(
            //   color: Colors.transparent,
            //   borderRadius: BorderRadius.circular(10), // Border radius for the container
            //   border: Border.all(color: Colors.black), // Border color and width
            //   boxShadow: [
            //     // BoxShadow(
            //     //   color: Colors.grey.withOpacity(0.5), // Shadow color
            //     //   spreadRadius: 5, // Spread radius
            //     //   blurRadius: 7, // Blur radius
            //     //   offset: Offset(0, 3), // Offset of the shadow
            //     // ),
            //   ],
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Container(), flex: 2),
                const SizedBox(height: 30),
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
                              "LOGIN",
                              style: TextStyle(
                                fontSize: 38,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5.0,
                                    color: Colors.white,
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
                const SizedBox(height: 14),
            Container(
              padding: EdgeInsets.all(16), // Padding for the container
              decoration: BoxDecoration(
                color: Color(0xFF4D7DBA),
                border: Border.all(color: Colors.black), // Border around the container
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Shadow color
                    spreadRadius: 5, // Spread radius
                    blurRadius: 7, // Blur radius
                    offset: Offset(0, 3), // Offset
                  ),
                ],// Border radius for the container
              ),
              child: Column(
                // SizedBox(height: 12),
                children: [
                  TextFieldInput(
                    hintText: 'Enter your email',
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    textEditingController: _passwordController,
                    isPass: true,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    onTap: signin,
                    child: Container(
                      child: _isLoading
                          ? Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                          : Text('Sign In'),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black,width: 1),
                        borderRadius: BorderRadius.circular(15), // Border radius for the button
                        color: blueColor,
                      ),
                    ),
                  ),
                  SizedBox(
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
      ),
    );
  }
}