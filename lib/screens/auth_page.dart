import 'package:dyeus/screens/home_page.dart';
import 'package:dyeus/screens/otp_screen.dart';
import 'package:dyeus/widgets/auth_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sms_autofill/sms_autofill.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  int _selectedIndex = 0;
  String myPhoneNumber = '';
  bool isLoading = false;
  String verifyId = '';
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController myNumberController = TextEditingController();

  snackBar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.black, width: 0.3)),
              width: 153,
              height: 40,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //     builder: (ctx) => const AuthPage()));
                    },
                    child: Container(
                        height: 50,
                        width: 76,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: _selectedIndex == 0
                                ? const Color.fromARGB(255, 165, 221, 81)
                                : null),
                        child: Center(
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                                color: _selectedIndex == 0
                                    ? Colors.black
                                    : Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                  // const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //     builder: (ctx) => const AuthPage()));
                    },
                    child: Container(
                        height: 50,
                        width: 76,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: _selectedIndex != 0
                                ? const Color.fromARGB(255, 165, 221, 81)
                                : null),
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                color: _selectedIndex != 0
                                    ? Colors.black
                                    : Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              'Welcome Back!!',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
            const SizedBox(height: 45),
            const Text(
              'Please login with your phone number',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntlPhoneField(
                initialCountryCode: 'IN',
                controller: myNumberController,
                dropdownTextStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                cursorColor: Colors.grey,
                keyboardType: TextInputType.number,
                keyboardAppearance: Brightness.dark,
                // initialValue: 'Phone Number',
                showDropdownIcon: false,
                flagsButtonMargin: const EdgeInsets.only(left: 10),
                decoration: InputDecoration(
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      )),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      )),
                  fillColor: Colors.white24,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      )),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  floatingLabelStyle: const TextStyle(
                      color: Colors.pink, fontWeight: FontWeight.normal),
                  label: const Text(
                    'Phone Number',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      // color: Colors.red,
                      fontSize: 18),
                ),
                onChanged: (phone) {
                  //debugPrint(phone.completeNumber);
                  myPhoneNumber = phone.completeNumber;
                },
                onCountryChanged: (country) {
                  //debugPrint('Country changed to: ' + country.name);
                },
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              height: 60,
              // decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  signInWithPhone();
                },
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 165, 221, 81),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Continue',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10, left: 10),
                  height: 0.8,
                  width: 135,
                  decoration: const BoxDecoration(color: Colors.grey),
                ),
                const Text(
                  'OR',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  height: 0.8,
                  width: 135,
                  decoration: const BoxDecoration(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 15),
            buildButtons(() {}, 'Connect to Metamask', Colors.white70,
                const Icon(Icons.auto_fix_normal_sharp)),
            buildButtons(() async {
              User? user = await AuthHandler.signInWithGoogle();
              if (user != null) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => const HomePage()));
              }
            }, 'Connect to Google', Colors.white70,
                const Icon(Icons.golf_course)),
            buildButtons(() {}, 'Connect to Apple', Colors.black,
                const Icon(Icons.apple)),
            const SizedBox(height: 15),
            Center(
              child: RichText(
                  text: TextSpan(children: [
                const TextSpan(
                    text: "Dont't have an account?",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //     builder: (ctx) => const AuthPage()));
                      },
                    text: ' Sign Up',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 165, 221, 81),
                        fontWeight: FontWeight.bold))
              ])),
            )
          ]),
        ),
      ),
    );
  }

  buildButtons(Function function, String text, Color colour, Icon icon) {
    return Container(
      width: double.infinity,
      height: 60,
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
      child: ElevatedButton(
        onPressed: (() {
          function();
        }),
        style: ElevatedButton.styleFrom(
            primary: colour,
            // primary: const Color.fromARGB(255, 165, 221, 81),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(child: icon),
            Text(
              text,
              style: TextStyle(
                  color: colour == Colors.black ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  signInWithPhone() async {
    var appSignature = await SmsAutoFill().getAppSignature;

    await auth.verifyPhoneNumber(
        phoneNumber: myPhoneNumber,
        verificationCompleted: (v) {
          setState(() async {
            isLoading = false;
          });
        },
        verificationFailed: (verificationFailed) async {
          setState(() {
            isLoading = false;
          });
          // snackBar(verificationFailed.toString());
        },
        codeSent: (vId, token) async {
          setState(() {
            isLoading = false;
            verifyId = vId;
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (ctx) => OtpScreen(
                        auth: auth,
                        verificationId: verifyId,
                        phoneNum: myPhoneNumber,
                        appSignature: appSignature,
                      )),
            );
          });
        },
        codeAutoRetrievalTimeout: (v) {
          // snackBar(v.toString());
          setState(() {
            isLoading = false;
          });
        });
  }
}
