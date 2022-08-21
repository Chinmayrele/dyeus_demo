import 'package:dyeus/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen(
      {Key? key,
      required this.auth,
      required this.phoneNum,
      required this.appSignature,
      required this.verificationId})
      : super(key: key);
  final FirebaseAuth auth;
  final String verificationId;
  final String phoneNum;
  final String appSignature;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with CodeAutoFill {
  String currentText = '';
  String curntCode = '';
  String verifyId = '';
  bool isLoad = false;
  bool resendLoad = false;
  // Timer? timer;
  // int counter = 5;

  TextEditingController otpEditingController = TextEditingController();

  @override
  void codeUpdated() {
    // TODO: implement codeUpdated
  }

  @override
  void initState() {
    listenOtp();
    super.initState();
  }

  void listenOtp() async {
    await SmsAutoFill().unregisterListener();
    listenForCode();
    await SmsAutoFill().listenForCode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SmsAutoFill().unregisterListener();
  }

  void signInWithPhoneCredential(PhoneAuthCredential phoneCredential) async {
    setState(() {
      isLoad = true;
    });
    try {
      if (widget.auth.currentUser != null) {}
      final authCredential =
          await widget.auth.signInWithCredential(phoneCredential);
      setState(() {
        isLoad = false;
      });

      if (authCredential.user != null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => const HomePage()),
            (route) => false);
        snackBar('Welcome to our app!!!');
      }
    } on FirebaseException catch (e) {
      // snackBar(e.message.toString());
      setState(() {
        isLoad = false;
      });
    }
  }

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
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 55),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const SizedBox(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 28,
                  ),
                )),
            const SizedBox(height: 25),
            const Text(
              'Enter Otp',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 36),
            ),
            const SizedBox(height: 19),
            Text(
              'A 6 digit code has been sent to ${widget.phoneNum}',
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            const SizedBox(height: 15),
            RichText(
                text: TextSpan(children: [
              const TextSpan(
                  text: 'Incorrect Number?',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pop();
                    },
                  text: '  Change',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 165, 221, 81),
                  ))
            ])),
            const SizedBox(height: 110),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: PinFieldAutoFill(
                currentCode: curntCode,
                codeLength: 6,
                onCodeChanged: (val) {
                  setState(() {
                    curntCode = val.toString();
                    if (curntCode.length == 6) {
                      PhoneAuthCredential phoneCredential =
                          PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: otpEditingController.text,
                      );
                      signInWithPhoneCredential(phoneCredential);
                    }
                  });
                },
                decoration: UnderlineDecoration(
                  lineHeight: 1,
                  textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                  colorBuilder:
                      FixedColorBuilder(Colors.black.withOpacity(0.3)),
                ),
                onCodeSubmitted: (val) {
                  debugPrint(val);
                },
                controller: otpEditingController,
                keyboardType: TextInputType.number,
              ),
            ),
            buildButtons(
              () async {
                await resendOtp(widget.phoneNum);
                listenOtp();
              },
              'Resend Otp',
              const Color.fromARGB(255, 201, 209, 189),
            )
          ],
        ),
      ),
    );
  }

  buildButtons(Function function, String text, Color colour) {
    return Container(
      width: double.infinity,
      height: 60,
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 12, top: 40),
      child: ElevatedButton(
        onPressed: () {
          function();
        },
        style: ElevatedButton.styleFrom(
            primary: colour,
            // primary: const Color.fromARGB(255, 165, 221, 81),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
        child: Text(
          text,
          style: TextStyle(
              color: colour == Colors.black ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ),
    );
  }

  resendOtp(String phoneNum) async {
    var appSignature = await SmsAutoFill().getAppSignature;

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNum,
        verificationCompleted: (v) {
          setState(() async {
            resendLoad = false;
          });
        },
        verificationFailed: (verificationFailed) async {
          setState(() {
            resendLoad = false;
          });
          // snackBar(verificationFailed.toString());
        },
        codeSent: (vId, token) async {
          setState(() {
            resendLoad = false;
            verifyId = vId;
          });
        },
        codeAutoRetrievalTimeout: (v) {
          // snackBar(v.toString());
          setState(() {
            resendLoad = false;
          });
        });
  }
}
