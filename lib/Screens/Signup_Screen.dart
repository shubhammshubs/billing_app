// import 'package:ecom/User_Credentials/login_Screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// class SignUpScreen extends StatefulWidget {
//   final String mobileNumber;
//
//   SignUpScreen({required this.mobileNumber});
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   bool agreedToTerms = false; // Track whether the user has agreed to the Terms & Conditions.
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//       SingleChildScrollView(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: 70,),
//               const Text( "Create Account",
//                 style: TextStyle(color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 30,
//                 ),
//               ),
//               const SizedBox(height: 10,),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Fill your information below or register",
//                     style: TextStyle(
//                       color: Colors.black45,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       // Navigate to the Sign Up screen
//                       // You can use Navigator to navigate to the sign-up screen.
//                     },
//                     child: const Text(
//                       "with your account.",
//                       style: TextStyle(
//                         color: Colors.black45,
//                         // fontWeight: FontWeight.bold,
//                         // decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 30,),
//
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: TextFormField(
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: const InputDecoration(
//                     labelText: 'Name',
//                     hintText: 'Enter your name',
//                     prefixIcon: Icon(Icons.drive_file_rename_outline),
//                     border: OutlineInputBorder(),
//                   ),
//                   onChanged: (String value){
//
//                   },
//                   validator: (value){
//                     return value!.isEmpty ? 'Please  Enter Email' : null;
//                   },
//                 ),
//               ),
//               const SizedBox(height: 30,),
//
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: TextFormField(
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                     hintText: 'Enter Email',
//                     prefixIcon: Icon(Icons.email),
//                     border: OutlineInputBorder(),
//                   ),
//                   onChanged: (String value){
//
//                   },
//                   validator: (value){
//                     return value!.isEmpty ? 'Please  Enter Email' : null;
//                   },
//                 ),
//               ),
//               const SizedBox(height: 30,),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: TextFormField(
//                   keyboardType: TextInputType.visiblePassword,
//                   decoration: const InputDecoration(
//                     labelText: 'Password',
//                     hintText: 'Enter Password',
//                     prefixIcon: Icon(Icons.password),
//                     border: OutlineInputBorder(),
//                   ),
//                   onChanged: (String value){
//
//                   },
//                   validator: (value){
//                     return value!.isEmpty ? 'Please  Enter Password' : null;
//                   },
//                 ),
//               ),
//               const SizedBox(height: 10,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Checkbox(
//                     value: agreedToTerms,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         agreedToTerms = value ?? false;
//                       });
//                     },
//                   ),
//                   const Text(
//                     "Agree with ",
//                     style: TextStyle(
//                       color: Colors.black45,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       // Navigate to the Sign Up screen
//                       // You can use Navigator to navigate to the sign-up screen.
//                     },
//                     child: const Text(
//                       "Terms & Conditions",
//                       style: TextStyle(
//                         color: Colors.green,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20,),
//
//
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 35),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20.0),
//                   child: MaterialButton(
//
//                     minWidth: double.infinity,
//                     onPressed:() {},
//                     child: const Text('Sign Up',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),),
//
//                     color: Colors.green,
//                     textColor: Colors.white,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 30,),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 35),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Divider(
//                         color: Colors.black45 , // Color of the lines
//                         thickness: 1, // Thickness of the lines
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 8),
//                       child: Text(
//                         'Or Sign up with',
//                         style: TextStyle(
//                           color: Colors.black45,
//                           // backgroundColor: Colors.teal,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Divider(
//                         color: Colors.black45, // Color of the lines
//                         thickness: 1, // Thickness of the lines
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30,),
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//
//                   CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 35,
//                     child: ShaderMask(
//                       shaderCallback: (Rect bounds) {
//                         return const LinearGradient(
//                           colors: [Colors.red,Colors.yellow,Colors.green, Colors.blue], // Define the colors you want to mix
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomRight,
//                         ).createShader(bounds);
//                       },
//                       child: const Icon(
//                         FontAwesomeIcons.google,
//                         size: 34,
//                         color: Colors.white, // Set the default color of the icon
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   const CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 35,
//                     child: Icon(
//                       Icons.apple, // Replace with the appropriate Google icon
//                       color: Colors.black, // Change the color to match the Google icon
//                       size: 38,
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   const CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 35,
//                     child: Icon(
//                       FontAwesomeIcons.facebookF, // Replace with the appropriate Facebook icon
//                       color: Colors.blue, // Change the color to match the Facebook icon
//                       size: 34,
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//
//                   const CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 35 ,
//                     child: Icon(
//                       FontAwesomeIcons.mobileScreen, // Replace with the appropriate Facebook icon
//                       color: Colors.black, // Change the color to match the Facebook icon
//                       size: 34,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 25,),
//               // Don't have an account? Sign Up.
//               const Text(
//                 "Don't have an account? ",
//                 style: TextStyle(
//                   color: Colors.black45,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) =>
//                           LoginScreen()));
//                 },
//                 child: const Text(
//                   "Sign In",
//                   style: TextStyle(
//                     color: Colors.green,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.center,
//               //   children: [
//               //     GestureDetector(
//               //       onTap: () {
//               //         // Add your logic for handling "Forgot Password?" button click here
//               //       },
//               //       child: const Text(
//               //         "Sign Up",
//               //         style: TextStyle(
//               //           color: Colors.green,
//               //           fontSize: 14,
//               //           decoration: TextDecoration.underline, // Add underline decoration here
//               //         ),
//               //       ),
//               //     ),
//               //   ],
//               // )
//
//             ],
//           ),
//
//         ),
//       ),
//
//     );
//   }
// }



import 'dart:convert';
// import 'dart:js';

import 'package:billing_app/Screens/Hom_Screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'login_Screen.dart';



class SignUpScreen extends StatefulWidget {
  // final String mobileNumber;

  // final Product? product;
  // final String mobileNumber;


  // SignupVerifyOTP({required this.product,
  //   required this.mobileNumber
  // });

  // SignUpScreen({
  //   // this.product ,
  //   // required this.mobileNumber
  // });

  @override
  State<SignUpScreen> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _mobileController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  TextEditingController countrycode = TextEditingController();
  // late TextEditingController _mobileController; // Declare _mobileController

  String? selectedGender;
  List<String> genderOptions = ['Male', 'Female'];

  @override
  void initState() {
    countrycode.text="+91";
    // _mobileController = TextEditingController(text: widget.mobileNumber); // Initialize _mobileController with the provided mobile number

    super.initState();
  }

  Future<void> _signUp(BuildContext context) async {


    final String apiUrl =
        'https://apip.trifrnd.com/fruits/inv.php?apicall=signup';

    // Simulate a delay of 1 second
    await Future.delayed(const Duration(seconds: 1));

    final response = await http.post(Uri.parse(apiUrl),
        body: {
          "username": _nameController.text,
          "email": _emailController.text,
          "mobile": _mobileController.text,
          "password": _passwordController.text,
          "gender": selectedGender,

        });
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("Response body: ${response.body}");

      print("Decoded data: $responseData");

      if (responseData == "User registered successfully") {
        // Login successful, you can navigate to the next screen
        print("Register successful");
        final user = json.decode(response.body)[0];

        Fluttertoast.showToast(
          msg: response.body,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        // Use Navigator to push HomePage onto the stack
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) =>
              HomeScreen(
                mobileNumber: _mobileController.text,
              )
          ),
        );

      } else {
        // Login failed, show an error message
        print("Login failed");
        Fluttertoast.showToast(
          msg: "You Are Already Registered, Please Login to Continue",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginScreen()
            //     HomePage(
            //   mobileNumber: _mobileController.text,
            //       // product: widget.product,
            // ),
          ),
        );
      }
    } else {
      // Handle error if the API call was not successful
      print("API call failed");
      Fluttertoast.showToast(
        msg: "Server Connction Error!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to the SignInPage when the back button is pressed
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => LoginScreen()),
        // );
        // Return false to prevent the default back button behavior
        return false;
      },
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Register Screen'),
            backgroundColor: Colors.orange,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50,),
                // Text(
                //   'Register',
                //   style: TextStyle(color: Colors.black,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 30,
                //   ),
                //   // style: TextStyle(
                //   //     fontSize: 35,
                //   //     color: Colors.teal.shade300,
                //   //     fontWeight: FontWeight.bold
                //   // ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Code for Entering Name
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                hintText: 'Enter Name',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String value){
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 30,),

                          // Code for Entering Email

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter Email',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String value){

                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your email';
                                } else if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                                // Code for Entering Mobile Number
                              },
                            ),
                          ),
                          const SizedBox(height: 30,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.mobile_friendly,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: TextFormField(
                                      readOnly: true, // Set the field to read-only
                                      controller: countrycode,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "|",
                                    style: TextStyle(fontSize: 33, color: Colors.grey),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      // readOnly: true, // Set the field to read-only
                                      // readOnly: true, // Set the field to read-only
                                      keyboardType: TextInputType.number,
                                      controller: _mobileController, // Use the _mobileController to display the mobile number
                                      // keyboardType: TextInputType.number,
                                      // controller: _mobileController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Phone',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30,),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Gender',
                                prefixIcon: Icon(FontAwesomeIcons.venusMars),
                                border: OutlineInputBorder(),
                              ),
                              value: selectedGender,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedGender = newValue;
                                });
                              },
                              items: genderOptions.map((String gender) {
                                return DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(gender),
                                );
                              }).toList(),
                            ),
                          ),


                          const SizedBox(height: 30,),

                          // Code for Entering Password

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter Password ',
                                prefixIcon: Icon(Icons.password),
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String value){

                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a password';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 30,),

                          // Code for Submit button

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              onPressed: () async {
                                // Handle login logic here
                                if (_formKey.currentState!.validate()) {

                                  // Perform the login
                                  await _signUp(context);

                                }
                              },
                              color: Colors.orange,
                              textColor: Colors.white,
                              child: const Text('Register',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context)=> LoginScreen(),
                                  ));
                            },
                            child: const Text(
                              "Go TO Login",
                              style: TextStyle(
                                color: Colors.orange,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                        ],
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
