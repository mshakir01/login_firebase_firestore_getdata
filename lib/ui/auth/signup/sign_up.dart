import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/ui/utils/utils.dart';
import 'package:firebase/ui/widget/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/text_constant.dart';
import '../../../constant/text_style.dart';
import '../../home/home_Screen.dart';
import '../login/login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff181848),
      // appBar: AppBar(
      //   title: const Text("Sign Up Form"),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      logintext,textAlign: TextAlign.start,
                      style: heading1,
                    ),
                    SizedBox(height: 5,),
                    Text(
                      wback,
                      style: heading2,
                    ),
                    SizedBox(height: 5,),
                    Text(
                      lContinue,
                      style: heading3,
                    ),
                  ],
                ),
              ],
            ),
          ),

        const  SizedBox(height: 30,),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
            child: Padding(
              padding:  EdgeInsets.all(20.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: nameController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: "Enter Name",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Email';
                              }
                              return null;
                            },
                          ),
                     const    SizedBox(height: 25,),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: "Email",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Email';
                              }
                              return null;
                            },
                          ),
                        const   SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: "Password",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Password';
                              }
                              return null;
                            },
                          ),
                        ],
                      )),
                const   SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: RoundButton(
                      text: "Sign Up ",
                      onTap: () {
                        login();
                      },
                    ),
                  ),
                const  SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => LoginScreen()));
                          },
                          child: const Text("Sign in"))
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void getData() async {
    User? user = await FirebaseAuth.instance.currentUser;
    print("useer${user!.uid.toString()}");
    var vari = await FirebaseFirestore.instance
        .collection('UserData')
        .doc(user.uid)
        .get();

    setState(() {
      // name = vari.data()!['name'];
      print("asdfghjksdfhjk");
      // email = vari.data()!['email'];
    });
  }

  Future login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      _auth
          .createUserWithEmailAndPassword(
              email: emailController.text.toString(),
              password: passwordController.text.toString())
          .then((value) {
        FirebaseFirestore.instance
            .collection('UserData')
            .doc(value.user!.uid)
            .set({
          'name': nameController.text,
          'email': emailController.text,
        });
      }).onError((error, stackTrace) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));

        getData();
        Utils().toastMessage(error.toString());
      });
    }
  }
}
