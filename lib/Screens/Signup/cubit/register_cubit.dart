import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/Login/model/loginModel.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/Screens/helpers/hive_helpers.dart';
import 'package:plant_app/Screens/navigation/navigation_screen.dart';
import 'package:plant_app/const.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  final registerkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final repasswordController = TextEditingController();

  void register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    emit(RegisterLoadingState());

    AuthenticationModel model = AuthenticationModel();
    try {
      final response = await DioHelpers.postData(path: RegisterPath, body: {
        "email": email,
        "password": password,
        "name": name,
        "phone": phoneNumber
      });

      model = AuthenticationModel.fromJson(response.data);
      if (model.status ?? false) {
        HiveHelpers.setToken(model.data?.token);
        DioHelpers.setToken(model.data?.token ?? '');

        // Save user to Firestore
        await FirebaseFirestore.instance.collection('users').doc(email).set({
          'email': email,
          'name': name,
          'phone': phoneNumber,
          'token': model.data?.token,
        });

        Get.offAll(() => const NavigationScreen());
        emit(RegisterSuccessState());
      } else {
        emit(RegisterErrorState(model.message ?? "Error"));
      }
    } catch (e) {
      emit(RegisterErrorState(e.toString()));
    }
  }

}
