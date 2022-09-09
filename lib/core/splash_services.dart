import 'dart:async';import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ui/auth/login/login.dart';
import '../ui/home/home_Screen.dart';


 class SplashServices{
   void isLogin(BuildContext context){

     final auth =FirebaseAuth.instance;
     final user = auth.currentUser;

     if(user !=null){
       Timer(
         const  Duration(seconds: 5),
               () => Navigator.pushReplacement(
               context, MaterialPageRoute(builder: (context) => HomeScreen())));

     }else{
       Timer(
           Duration(seconds: 5),
               () => Navigator.pushReplacement(
               context, MaterialPageRoute(builder: (context) => LoginScreen())));

     }
     }


 }