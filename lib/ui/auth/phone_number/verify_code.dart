import 'package:firebase/ui/home/home_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';
import '../../widget/round_button.dart';

class VerfiyCodeScreen extends StatefulWidget {
  final String  verificationId;
  const VerfiyCodeScreen({Key? key,required this.verificationId}) : super(key: key);

  @override
  State<VerfiyCodeScreen> createState() => _VerfiyCodeScreenState();
}

class _VerfiyCodeScreenState extends State<VerfiyCodeScreen> {

  bool loading = false;
  TextEditingController verifyCodeController = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            TextFormField(
              controller: verifyCodeController,
              decoration: const InputDecoration(
                hintText: "6 digit code",
              ),
            ),
            SizedBox(
              height: 80.h,
            ),
            RoundButton(
                text: "Verify",
                onTap: () async {
                  setState(() {
                    loading =true;

                  });
                  final credential=PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: verifyCodeController.text.toString());

                  try{
                    await  auth.signInWithCredential(credential);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                  }catch(e){
                    setState(() {
                      loading =false;

                    });
                    Utils().toastMessage(e.toString());
                  }
                }),
          ],
        ),
      ),
    );
  }
}
