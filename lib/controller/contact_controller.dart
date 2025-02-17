import 'package:flutter/cupertino.dart';
import 'package:flutter_exam/model/contact_model.dart';
import 'package:flutter_exam/services/db_services.dart';
import 'package:flutter_exam/services/firebase_services.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  RxList<Contact> contactList = <Contact>[].obs;
  RxList<Contact> filteredList = <Contact>[].obs;
  RxString filter = 'All'.obs;
  var txtName = TextEditingController();
  var txtPhone = TextEditingController();
  var txtEmail = TextEditingController();
  RxBool isFavourite = false.obs;
  RxString category = 'Other'.obs;

  //set
  void setController(Contact contact) {
    txtName.text = contact.name;
    txtPhone.text = contact.phone;
    txtEmail.text = contact.email;
    category.value = contact.category;
    isFavourite.value = contact.isFavourite == 1 ? true : false;
  }

  //reset
  void resetController() {
    txtName.clear();
    txtPhone.clear();
    txtEmail.clear();
    category.value = 'Other';
    isFavourite.value = false;
  }

  // set Category
  void setCat(String value) {
    category.value = value;
  }

  // set fav
  void setFav(bool value) {
    isFavourite.value = value;
  }

  // fetch record
  Future<void> fetchAllContacts() async {
    final record = await DbServices.dbServices.readAllRecords();
    contactList.value = record.map((e) => Contact.fromJson(e)).toList();
  }

  // fetch category filtered record
  Future<void> fetchFilteredContact(String value) async {
    if (value != 'All' && value != 'Favourite') {
      final record = await DbServices.dbServices.getByCategory(value);
      contactList.value = record.map((e) => Contact.fromJson(e)).toList();
    } else if(value == 'Favourite') {
      final record = await DbServices.dbServices.getByFavourites();
      contactList.value = record.map((e) => Contact.fromJson(e)).toList();
    } else {
      await fetchAllContacts();
    }
  }

  // add contact
  Future<void> addContact() async {
    final name = txtName.text;
    final phone = txtPhone.text;
    final email = txtEmail.text;

    if (name.isNotEmpty && phone.isNotEmpty && email.isNotEmpty) {
      Contact contact = Contact(
          name: name,
          phone: phone,
          email: email,
          category: category.value,
          isFavourite: isFavourite.value ? 1 : 0);
      await DbServices.dbServices.insertRecord(contact);
      await fetchAllContacts();
    }
  }

  // add contact
  Future<void> updateContact(Contact contact) async {
    contact.name = txtName.text;
    contact.phone = txtPhone.text;
    contact.email = txtEmail.text;
    contact.category = category.value;
    contact.isFavourite = isFavourite.value ? 1 : 0;

    if (contact.name.isNotEmpty &&
        contact.phone.isNotEmpty &&
        contact.email.isNotEmpty) {
      await DbServices.dbServices.updateRecord(contact);
      await fetchAllContacts();
    }
  }

  //delete
  Future<void> deleteContact(int id) async {
    await DbServices.dbServices.deleteRecord(id);
    await fetchAllContacts();
  }

  // upload to cloud
  Future<void> uploadToCloud() async {
    await FirebaseServices.fbServices.uploadToCloud();
    await fetchAllContacts();
  }

  // sync with cloud
  Future<void> fetchFromCloud() async {
    await FirebaseServices.fbServices.fetchFromFirebase();
    await fetchAllContacts();
  }

  @override
  void dispose() {
    txtName.dispose();
    txtPhone.dispose();
    txtEmail.dispose();
    super.dispose();
  }
}
