import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

var db = FirebaseFirestore.instance;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCsg9CJYVCF-9jBJ_6TlNJbaZkc08kgAng',
    appId: '1:589285434459:web:e5f0d905986b56d3148b7e',
    messagingSenderId: '589285434459',
    projectId: 'hcdproject2',
    authDomain: 'hcdproject2.firebaseapp.com',
    storageBucket: 'hcdproject2.appspot.com',
    measurementId: 'G-7VB5B5H9G3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBIvDAw46DRmZk12_E1Xts06wqUuH3y9rE',
    appId: '1:589285434459:android:d4cde87c8c67eb5a148b7e',
    messagingSenderId: '589285434459',
    projectId: 'hcdproject2',
    storageBucket: 'hcdproject2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAud1Y6wTk-eGKE1jKhFGZJSzqUjyZP-4k',
    appId: '1:589285434459:ios:453b9cd73922a32f148b7e',
    messagingSenderId: '589285434459',
    projectId: 'hcdproject2',
    storageBucket: 'hcdproject2.appspot.com',
    iosBundleId: 'com.example.hcdProject2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAud1Y6wTk-eGKE1jKhFGZJSzqUjyZP-4k',
    appId: '1:589285434459:ios:20e16ecd72462756148b7e',
    messagingSenderId: '589285434459',
    projectId: 'hcdproject2',
    storageBucket: 'hcdproject2.appspot.com',
    iosBundleId: 'com.example.hcdProject2.RunnerTests',
  );

  // Add this function to store client details in Firestore
  static void addClientDetails(String clientName, String companyName, String state, String mobileNumber, String gstNumber) {
    db.collection("Clients").add({
      'name': clientName,
      'companyName': companyName,
      'state': state,
      'mobileNumber': mobileNumber,
      'gstNumber': gstNumber,
    }).then((value) {
      print("Client details added successfully!");
    }).catchError((error) {
      print("Failed to add client details: $error");
    });
  }

  // Add function to store email and password when client logs in
  static void storeLoginDetails(String email, String password) {
    db.collection("Logins").add({
      'email': email,
      'password': password,
    }).then((value) {
      print("Login details stored successfully!");
    }).catchError((error) {
      print("Failed to store login details: $error");
    });
  }

  // Add function to store order details in Firestore
  static Future<void> addOrderDetails(String clientName, String companyName, List<Map<String, dynamic>> orderItems) async {
    try {
      await db.collection("Orders").add({
        'clientName': clientName,
        'companyName': companyName,
        'orderItems': orderItems,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Order details added successfully!");
    } catch (error) {
      print("Failed to add order details: $error");
    }
  }
}

