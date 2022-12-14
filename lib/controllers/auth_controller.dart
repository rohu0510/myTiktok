import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:latest_collage_p/constants.dart';
import 'package:latest_collage_p/models/user.dart' as model;
import 'package:latest_collage_p/views/screens/auth/login_screen.dart';
import 'package:latest_collage_p/views/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  late Rx<File?> _pickedImage;
  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?> (firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if(user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }
  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage != null) {
      Get.snackbar(
          'Profile Picture',
          'You have sucessfully selected Profile picture'
      );
    }
    _pickedImage = Rx<File?> (File(pickedImage!.path));
  }

  //get name => null;

  //upload to firebase
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser !.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
  //registering the user
  Future<void> registerUser(
      String username, String email, String password, File? image) async {
    try{
      if(username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null
      ) {
        //save user
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password
        );
        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
          name: username,
          email: email,
          uid: cred.user!.uid,
          profilePhoto: downloadUrl,
        );
        await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set(user.toJson());
      } else {
        Get.snackbar(
            'Error Occured',
            'Please enter all the fields',
        );
      }
    }catch(e){
      Get.snackbar(
          'Error Occured',
          e.toString()
      );
    }
  }
  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print('log sucess');
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Logging in',
        e.toString(),
      );
    }
  }

  // forgotPassword(String email) async {
  //   await firebaseAuth.sendPasswordResetEmail(email: email);
  // }
  void signOut() async {
    await firebaseAuth.signOut();
  }
}
