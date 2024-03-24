import "dart:ui";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:instagram_flutter/resources/auth_methods.dart";
import "package:instagram_flutter/responsive/mobile_screen_layout.dart";
import "package:instagram_flutter/responsive/responsive_layout_screen.dart";
import "package:instagram_flutter/responsive/web_screen_layout.dart";
import "package:instagram_flutter/screens/signin_screen.dart";
import 'package:instagram_flutter/screens/register_student.dart';
import 'package:instagram_flutter/screens/register_tutor.dart';
import "package:instagram_flutter/utilis/colors.dart";
import "package:instagram_flutter/utilis/utilis.dart";
import "package:instagram_flutter/widgets/text_field_input.dart";



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // @override
  // void dispose() {
  //   super.dispose();
  //   _emailController.dispose();
  //   _passwordController.dispose();
  // }

  // void loginUser() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   String res = await AuthMethods().loginUser(
  //       email: _emailController.text, password: _passwordController.text);
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   if (res != 'success') {
  //     showSnackBar(context, res);
  //   } else {
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(
  //         builder: (context) => const ResponsiveLayout(
  //             webScreenLayout: webScreenLayout(),
  //             mobileScreenLayout: MobileScreenLayout()),
  //       ),
  //     );
  //   }
  // }

  // void navigateToSignup() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => SignupScreen(),
  //     ),
  //   );
  // }

  void navigateToRegisterstudent() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterStudent(),
      ),
    );
  }

  void navigateToRegistertutor() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterTutor(),
      ),
    );
  }
  void navigateToSignin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignIn(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFAFE1AF).withOpacity(0.7),
      // Other Scaffold properties...
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF9B4C97).withOpacity(0.7),
                Color(0xFFE8BBE4).withOpacity(0.7),
                Color(0xFF9B4C97).withOpacity(0.3),
                Color(0xFFE8BBE4).withOpacity(0.3), // Light pink
                Color(0xFF9B4C97).withOpacity(0.3),
                Color(0xFFE8BBE4).withOpacity(0.7),
                Color(0xFF9B4C97).withOpacity(0.7),// Purple shade
              ],
            ),
            // color: Color(0xFF9370DB).withOpacity(0.2), // Unique purple shade with 30% opacity
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Flexible(child: Container(), flex: 2),
              //svg image
              // SvgPicture.asset(
              //   'assests/ic_instagram.svg',
              //   color: primaryColor,
              //   height: 64,
              // ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      // decoration: BoxDecoration(
                      //   gradient: LinearGradient(
                      //     begin: Alignment.topCenter,
                      //     end: Alignment.bottomCenter,
                      //     colors: [
                      //       Color(0xFF4E4376), // Purple
                      //       Color(0xFFA67DB8), // Lighter Purple
                      //     ],
                      //   ),
                      //
                      //   border: Border.all(color: Colors.black),
                      // ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 30,
                          ),
                          child: Text(
                            "P2PL",
                            style: TextStyle(
                              fontSize: 38,
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

              const Text(
                "Peer Power: Learn Smarter, Achieve Greater, Grow Together",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(20), // Adjust padding as needed
                decoration: BoxDecoration(
                  color: Color(0xFF9B4C97),
                  // gradient: LinearGradient(
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  //   colors: [
                  //     Color(0xFFE8BBE4), // Light pink
                  //     Color(0xFF9B4C97), // Purple shade
                  //   ],
                  // ),
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5), // Shadow color
                      spreadRadius: 5, // Spread radius
                      blurRadius: 7, // Blur radius
                      offset: Offset(0, 3), // Offset
                    ),
                  ],// Add border
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center contents vertically
                    crossAxisAlignment: CrossAxisAlignment.center, // Center contents horizontally
                    children: [
                      Text(
                        "Welcome \n  Peeps!",
                        style: TextStyle(fontSize: 32,
                        fontWeight: FontWeight.bold,
                        // fontStyle: FontStyle.italic,
                        fontFamily: 'Neuton'),
                      ),
                      SizedBox(height: 32),
                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(color: Colors.deepPurple ,width: 2),
                              ),
                              elevation: 5,
                              shadowColor: Colors.black,
                            ),
                            onPressed: navigateToRegisterstudent,
                            child: Container(
                              child: SizedBox(
                                width: 200,
                                child: Center(
                                  child: Text(
                                    "Register as a Student",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('OR'),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(color: Colors.deepPurple ,width: 2),
                              ),
                              elevation: 5,
                              shadowColor: Colors.black,
                            ),
                            onPressed: navigateToRegistertutor,
                            child: Container(

                              child: SizedBox(
                                width: 200,
                                child: Center(
                                  child: Text(
                                    "Register as a Tutor",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Already registered?",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "Click on Sign in",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: navigateToSignin,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: Colors.deepPurple ,width: 2),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black,
                        ),
                        child: SizedBox(
                          width: 200,
                          child: Center(
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
              ),



              //text field input for email
              // TextFieldInput(
              //   hintText: 'Enter your email',
              //   textInputType: TextInputType.emailAddress,
              //   textEditingController: _emailController,
              // ),
              // const SizedBox(
              //   height: 24,
              // ),
              //text field input for password
              // TextFieldInput(
              //   hintText: 'Enter your password',
              //   textInputType: TextInputType.text,
              //   textEditingController: _passwordController,
              //   isPass: true,
              // ),
              // const SizedBox(
              //   height: 24,
              // ),
              //button login
              // InkWell(
              //   onTap: loginUser,
              //   child: Container(
              //     child: _isLoading
              //         ? const Center(
              //             child: CircularProgressIndicator(
              //               color: primaryColor,
              //             ),
              //           )
              //         : const Text('Log in'),
              //     width: double.infinity,
              //     alignment: Alignment.center,
              //     padding: EdgeInsets.symmetric(vertical: 12),
              //     decoration: const ShapeDecoration(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.all(
              //           Radius.circular(4),
              //         ),
              //       ),
              //       color: blueColor,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 12,
              // ),
              Flexible(child: Container(), flex: 2),

              //Transitioning to signing up
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       child: Text("Don't have an account?"),
              //       padding: const EdgeInsets.symmetric(
              //         vertical: 8,
              //       ),
              //     ),
              // GestureDetector(
              //   onTap: navigateToSignup,
              //   child: Container(
              //     child: Text(
              //       "Sign Up.",
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     padding: const EdgeInsets.symmetric(
              //       vertical: 8,
              //     ),
              //   ),
              // ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}