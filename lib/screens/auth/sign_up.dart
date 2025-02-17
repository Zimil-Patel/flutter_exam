import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exam/screens/auth/sign_in.dart';
import 'package:flutter_exam/services/auth_services.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var txtEmail = TextEditingController();
    var txtPass = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SIGN IN TITLE
            Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),

            // email
            buildTextField(
              hintText: 'Email',
              icon: Icons.email,
              controller: txtEmail,
            ),

            // password
            buildTextField(
              hintText: 'Password',
              icon: Icons.password,
              controller: txtPass,
            ),

            SizedBox(height: 30),

            // SIGN IN BUTTON
            CupertinoButton(
              onPressed: () async {
                final result = await AuthServices.authServices
                    .signUpWithEmailPass(txtEmail.text, txtPass.text);

                if (result) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sign up success'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sign up failed'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              padding: EdgeInsets.zero,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Already have account? sign in'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
