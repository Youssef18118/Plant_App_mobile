import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/Login/LoginForm/LoginForm.dart';
import 'package:plant_app/Screens/Login/login.dart';
import 'package:plant_app/Screens/Signup/cubit/register_cubit.dart';
import 'package:plant_app/const.dart';

class register extends StatelessWidget {
  const register({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final cubit = context.read<RegisterCubit>();

    return Scaffold(
      body: BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if(state is RegisterSuccessState && !state.snackbarShown){
          Get.snackbar("Success", "Sign up Success", backgroundColor: Colors.green, colorText: Colors.white);
          state.snackbarShown = true;
        }
        if(state is RegisterErrorState && !state.snackbarShown){
          Get.snackbar("Error", state.message, backgroundColor: Colors.red, colorText: Colors.black); 
          state.snackbarShown = true;
        }

      },
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          if(state is RegisterLoadingState){
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.09, horizontal: width * 0.05),
                child: Form(
                  key: cubit.key,
                  child: Column(children: [
                    Container(
                      width: 70,
                      height: 70,
                      child: Image.asset(imagePath + "logoWithoutText.png"),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    const Text(
                      "Create New Account",
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      width: width * 0.68,
                      child: Column(children: [
                        tinyText("Set up your username and password."),
                        tinyText("You can always change it later.")
                      ]),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    CustomFormField(
                      height: height,
                      text: "Name",
                      isPasswordField: false,
                      controller: cubit.nameController,
                    ),
                    CustomFormField(
                      height: height,
                      text: "Email",
                      isPasswordField: false,
                      controller: cubit.emailController,
                      validator: (val) {
                        if (!val!.isEmail) {
                          return "Enter valid Email";
                        }
                      },
                    ),
                    CustomFormField(
                      height: height,
                      text: "Phone Number",
                      isPasswordField: false,
                      controller: cubit.phoneController,
                      validator: (val) {
                        if (val!.length != 11) {
                          return "Enter valid phone number";
                        }
                      },
                    ),
                    CustomFormField(
                      height: height,
                      text: "Password",
                      isPasswordField: true,
                      controller: cubit.passwordController,
                      validator: (val) {
                        if (val!.length < 5) {
                          return "There should be at least 5 characters long";
                        }
                      },
                    ),
                    CustomFormField(
                      height: height,
                      text: "Enter Password again",
                      isPasswordField: true,
                      controller: cubit.repasswordController,
                      validator: (val) {
                        if (val != cubit.passwordController.text) {
                          return "Passwords should be the same!!";
                        }
                      },
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    InkWell(
                      onTap: () {
                        if (cubit.key.currentState!.validate()) {
                          cubit.register(
                              email: cubit.emailController.text,
                              password: cubit.passwordController.text,
                              name: cubit.nameController.text,
                              phoneNumber: cubit.phoneController.text);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: height * 0.06,
                        decoration: BoxDecoration(
                            color: const Color(0xff5ac268),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                            child: Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(fontSize: 20),
                        ),
                        InkWell(
                            onTap: () {
                              Get.to(() => const Login());
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 20, color: Color(0xff5ac268)),
                            )),
                      ],
                    )
                  ]),
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}

Text tinyText(String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
        fontWeight: FontWeight.w900, fontSize: 15, color: Colors.grey[400]),
  );
}
