import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_exam/model/contact_model.dart';

import 'db_services.dart';

class FirebaseServices {
  FirebaseServices._();

  static FirebaseServices fbServices = FirebaseServices._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // insert / sync with firebase
  Future<void> fetchFromFirebase() async {
    final recordList = await _firestore.collection('contacts').get();

    final localContact = await DbServices.dbServices.readAllRecords();
    final localContactIds = localContact.map((contact) => contact['id']).toSet();

    for (var doc in recordList.docs) {
      final currentContact = doc.data();
      final contactId = currentContact['id'];

      if (!localContactIds.contains(contactId)) {
        Contact contact = Contact(
          id: currentContact['id'],
          name: currentContact['name'],
          phone: currentContact['phone'],
          email: currentContact['email'],
          category: currentContact['category'],
          isFavourite: currentContact['isFavourite'],
        );
        await DbServices.dbServices.insertRecord(contact);
      }
    }
  }

// fetch from sqflite and store to firebase
  Future<void> uploadToCloud() async {
    final records = await DbServices.dbServices.readAllRecords();
    final batch = _firestore.batch();

    for (var contact in records) {
      final id = contact['id'].toString();
      final ref = _firestore.collection('contacts').doc(id);

      batch.set(ref, contact, SetOptions(merge: true));
    }

    await batch.commit();
  }
}
