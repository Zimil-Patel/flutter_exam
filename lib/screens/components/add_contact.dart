import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exam/main.dart';
import 'package:flutter_exam/screens/auth/sign_in.dart';
import 'package:get/get.dart';

class AddContact extends StatelessWidget {
  const AddContact({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTextField(
              hintText: 'Enter name',
              icon: Icons.person,
              controller: contactController.txtName,
            ),
            buildTextField(
              hintText: 'Enter phone',
              icon: Icons.call,
              controller: contactController.txtPhone,
            ),
            buildTextField(
              hintText: 'Enter email',
              icon: Icons.email,
              controller: contactController.txtEmail,
            ),

            SizedBox(
              height: 20,
            ),

            // DROP DOWN MENU
            Obx(
              () => DropdownMenu(
                initialSelection: contactController.category.value,
                label: Text('Category'),
                onSelected: (value) {
                  contactController.setCat(value!);
                },
                dropdownMenuEntries: [
                  DropdownMenuEntry(
                    value: 'Family',
                    label: 'Family',
                  ),
                  DropdownMenuEntry(
                    value: 'Friend',
                    label: 'Friend',
                  ),
                  DropdownMenuEntry(
                    value: 'College',
                    label: 'College',
                  ),
                  DropdownMenuEntry(
                    value: 'Work',
                    label: 'Work',
                  ),
                  DropdownMenuEntry(
                    value: 'Other',
                    label: 'Other',
                  ),
                ],
              ),
            ),

            SizedBox(height: 12),

            // isFav switch
            Obx(
              () => Row(
                children: [
                  Text('Is this Favourite ?'),

                  SizedBox(width: 8),

                  Switch(
                    value: contactController.isFavourite.value,
                    onChanged: (value) {
                      contactController.setFav(value);
                    },
                  ),
                ],
              ),
            ),


            SizedBox(
              height: 20,
            ),


            Center(
              child: CupertinoButton(
                onPressed: () async {
                  log("Clicked");
                  await contactController.addContact();
                  contactController.resetController();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                padding: EdgeInsets.zero,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Text('ADD CONTACT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
