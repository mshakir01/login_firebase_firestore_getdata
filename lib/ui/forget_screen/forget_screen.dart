import 'package:firebase/ui/utils/utils.dart';
import 'package:firebase/ui/widget/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/container_box.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              Text("Forget Password"),
              SizedBox(
                height: 7.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.w),
                child: ContainerBox(
                  labelText: 'Email',
                  icon: Icons.mail_outline,
                  kCallBack: false,
                  controller: emailController,
                  kValidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: RoundButton(
                  text: 'Reset Password',
                  onTap: () {
                    print("object");
                    resetPassword();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    print("object");
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim())
        .onError(
            (error, stackTrace) => {Utils().toastMessage(error.toString())});
  }
}
