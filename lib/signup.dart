import 'package:capstonedemo/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';  
import 'package:get/get.dart';
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

   TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Signup() async{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text);
    Get.offAll(Wrapper());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Padding( 
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration:  InputDecoration(
                hintText: "Email",
              ),
            ),
            TextField(
              controller: password,
              decoration:  InputDecoration(
                hintText: "Password",
              ),
            ),
            ElevatedButton(
              onPressed: (()=> Signup()),
              child:  Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}