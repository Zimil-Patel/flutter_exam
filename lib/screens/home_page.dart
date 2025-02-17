import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exam/controller/contact_controller.dart';
import 'package:flutter_exam/main.dart';
import 'package:flutter_exam/model/contact_model.dart';
import 'package:flutter_exam/screens/auth/sign_in.dart';
import 'package:flutter_exam/screens/components/add_contact.dart';
import 'package:flutter_exam/screens/components/update_contact.dart';
import 'package:flutter_exam/services/auth_services.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APP BAR
      appBar: AppBar(
        title: Text('All Contacts'),
        actions: [
          IconButton(
              onPressed: () async {
                final res = await AuthServices.authServices.signOut();
                if (res) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInPage(),
                      ));
                }
              },
              icon: Icon(Icons.logout)),
        ],
      ),

      // BODY
      body: Column(
        children: [
          // sync
          Row(
            children: [
              Expanded(
                child: CupertinoButton(
                  onPressed: () async {
                    final result = await Connectivity().checkConnectivity();
                    if (result.contains(ConnectivityResult.mobile) ||
                        result.contains(ConnectivityResult.wifi)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Fetching from firebase...'),
                        ),
                      );
                      await contactController.fetchFromCloud();
                      ScaffoldMessenger.of(context).clearSnackBars();

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You are offline'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  padding: EdgeInsets.zero,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.sync,
                          color: Colors.white,
                        ),
                        Text(
                          'Sync with Cloud',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // sync
              Expanded(
                child: CupertinoButton(
                  onPressed: () async {
                    final result = await Connectivity().checkConnectivity();
                    if (result.contains(ConnectivityResult.mobile) ||
                        result.contains(ConnectivityResult.wifi)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Uploading to firebase...'),
                        ),
                      );
                      await contactController.uploadToCloud();
                      ScaffoldMessenger.of(context).clearSnackBars();

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You are offline'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  padding: EdgeInsets.zero,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.backup,
                          color: Colors.white,
                        ),
                        Text(
                          'Backup to Cloud',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 14,
          ),

          // DROP DOWN MENU
          Obx(
            () => Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                DropdownMenu(
                  initialSelection: contactController.filter.value,
                  label: Text('filter'),
                  onSelected: (value) async {
                    await contactController.fetchFilteredContact(value!);
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
                    DropdownMenuEntry(
                      value: 'All',
                      label: 'All',
                    ),
                    DropdownMenuEntry(
                      value: 'Favourite',
                      label: 'Favourite',
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder(
              future: contactController.fetchAllContacts(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Obx(
                    () => ListView.builder(
                      padding:
                          EdgeInsets.only(top: 16, left: 12, right: 12, bottom: 100),
                      itemCount: contactController.contactList.length,
                      itemBuilder: (context, index) {
                        if (contactController.contactList.isNotEmpty) {
                          return ContactTile(
                            contact: contactController.contactList[index],
                          );
                        } else {
                          return Center(
                            child: Text('No data found'),
                          );
                        }
                      },
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          contactController.resetController();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddContact(),
            ),
          );
        },
        child: Icon(Icons.person_add),
      ),
    );
  }
}

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.contact,
  });

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    String name = contact.name;
    String phone = contact.phone;
    String email = contact.email;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
      child: ListTile(
        leading: Column(
          children: [
            IconButton(
                onPressed: () {
                  contactController.setController(contact);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateContact(contact: contact),
                      ));
                },
                icon: Icon(Icons.edit)),
          ],
        ),
        title: Row(
          children: [
            // name
            Icon(Icons.person),
            SizedBox(width: 8),
            Text(
              name,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(width: 8),
            if (contact.isFavourite == 1)
              Icon(
                Icons.star,
                color: Colors.amber,
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // phone
            Row(
              children: [
                Icon(Icons.call),
                SizedBox(width: 8),
                Text(
                  phone,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            // email
            Row(
              children: [
                Icon(Icons.email),
                SizedBox(width: 8),
                Text(
                  email,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            // category
            Row(
              children: [
                Icon(Icons.category),
                SizedBox(width: 8),
                Text(
                  contact.category,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
            onPressed: () async {
              await contactController.deleteContact(contact.id!);
            },
            icon: Icon(Icons.delete)),
      ),
    );
  }
}
