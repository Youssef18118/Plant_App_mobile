import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/Screens/helpers/hive_helpers.dart';
import 'package:plant_app/Screens/navigation/navigation_screen.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';
import 'package:plant_app/const.dart';
import 'package:plant_app/Screens/Login/model/loginModel.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginkey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(LoginPasswordVisibilityChanged(isPasswordVisible));
  }

  void login({required String email, required String password, required BuildContext context}) async {
    emit(LoginLoadingState());

    AuthenticationModel model = AuthenticationModel();
    try {
      final response = await DioHelpers.postData(path: LoginPath, body: {
        "email": email,
        "password": password,
      });

      model = AuthenticationModel.fromJson(response.data);
      if (model.status ?? false) {
        HiveHelpers.setToken(model.data?.token);
        DioHelpers.setToken(model.data?.token ?? '');
        context.read<ProfileCubit>().init();
        Get.offAll(() => const NavigationScreen());
        emit(LoginSucessState());
      } else {
        emit(LogineErrorState(model.message ?? "Error"));
      }
    } catch (e) {
      emit(LogineErrorState(e.toString()));
    }
  }

  // Google Sign-In method
  Future<void> signInWithGoogle() async {
    emit(LoginLoadingState());

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // If the user cancels the Google Sign-In flow
        emit(LogineErrorState("Sign in aborted by user"));
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      // Logging user info to ensure it's correct
      print('User Credential: $userCredential');
      print('User: $user');

      if (user != null) {
        // Check if user exists in Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .get();

        if (userDoc.exists) {
          // Retrieve token from Firestore
          String? token = userDoc['token'];

          // Check if token is not null and set it in Hive and Dio
          if (token != null) {
            HiveHelpers.setToken(token);
            DioHelpers.setToken(token);

            emit(LoginSucessState());
            // Navigate to your app's home screen
            Get.offAll(() => const NavigationScreen());
          } else {
            emit(LogineErrorState("Token not found for the user"));
          }
        } else {
          emit(LogineErrorState("No account found for this email."));
          await signOut();
        }
      } else {
        // If the user is null after signing in, which is unlikely
        print('User is null after Google sign-in.');
        await signOut();
        emit(LogineErrorState("Google sign-in failed"));
      }
    } catch (e) {
      // print(e); // For debugging
      emit(LogineErrorState(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await googleSignIn.signOut();

      emit(LogOutSucessState());
    } catch (e) {
      emit(LogOutErrorState(e.toString()));
    }
  }


}
