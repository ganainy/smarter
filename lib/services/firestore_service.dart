import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

FirebaseFirestore firestore = FirebaseFirestore.instance;

CollectionReference eventsCollection = firestore.collection('events');
