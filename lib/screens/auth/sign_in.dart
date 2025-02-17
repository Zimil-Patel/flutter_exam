import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exam/screens/auth/sign_up.dart';
import 'package:flutter_exam/screens/home_page.dart';

import '../../services/auth_services.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

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
              'Sign in to Access Contacts',
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
                    .signInWithEmailPass(txtEmail.text, txtPass.text);

                if (result) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sign in failed'),
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
                  'Sign in',
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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SignUpPage(),
                  ));
                },
                child: Text('Don\'t have account? sign up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildTextField(
    {required String hintText,
    required IconData icon,
    required TextEditingController controller}) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(children: [
      SizedBox(
        width: 8,
      ),

      // icon
      Icon(icon),

      SizedBox(
        width: 8,
      ),

      // text field
      Expanded(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
        ),
      ),
    ]),
  );
}
