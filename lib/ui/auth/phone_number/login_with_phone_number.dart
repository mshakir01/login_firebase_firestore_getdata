import 'package:firebase/ui/auth/phone_number/verify_code.dart';
import 'package:firebase/ui/utils/utils.dart';
import 'package:firebase/ui/widget/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  TextEditingController phoneController = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone Number")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                hintText: "+92344 1345780",
              ),
            ),
            SizedBox(
              height: 80.h,
            ),
            RoundButton(
                text: "Login",
                onTap: () {
                  setState(() {
                    loading=true;
                  });
                  auth.verifyPhoneNumber(
                      phoneNumber: phoneController.text,
                      verificationCompleted: (e) {
                        setState(() {
                          loading=false;
                        });
                        Utils().toastMessage(e.toString());
                      },
                      verificationFailed: (e){
                        setState(() {
                          loading=false;
                        });
                        Utils().toastMessage(e.toString());
                      },
                      codeSent: (String verificationId,int? token){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>VerfiyCodeScreen(verificationId: verificationId,)));
                        setState(() {
                          loading=false;
                        });
                        },
                      codeAutoRetrievalTimeout: (e) {
                        setState(() {
                          loading=false;
                        });
                        Utils().toastMessage(e.toString());
                      });
                }),
          ],
        ),
      ),
    );
  }
}
