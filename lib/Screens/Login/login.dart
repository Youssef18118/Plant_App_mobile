import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/Login/LoginForm/LoginForm.dart';
import 'package:plant_app/Screens/Login/LoginWidgets.dart';
import 'package:plant_app/Screens/Login/cubit/login_cubit.dart';
import 'package:plant_app/Screens/Signup/register.dart';
import 'package:plant_app/const.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final cubit = context.read<LoginCubit>();

    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
        if(state is LogineErrorState){
          Get.snackbar("Error", state.message, backgroundColor: Colors.red, colorText: Colors.black); 
        }          
        },
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            if (state is LoginLoadingState) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.09, horizontal: width * 0.05),
                  child: Form(
                    key: cubit.loginkey,
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          child: Image.asset(imagePath + "logoWithoutText.png"),
                        ),
                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 30),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          width: width * 0.65,
                          child: smallText(
                              "Log in to your account using email or social networks"),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        
                        LoginButton(height, "Google", image: "google.png",
                            onTap: () {
                          context.read<LoginCubit>().signInWithGoogle();
                        }),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        smallText("Or continue with social account"),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        CustomFormField(
                          height: height,
                          text: "Email",
                          isPasswordField: false,
                          controller: cubit.emailController,
                          validator: (val) {
                            if (!val!.isEmail) {
                              return "Enter valid Email format";
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
                        
                        SizedBox(
                          height: height * 0.02,
                        ),
                        InkWell(
                          onTap: () {
                            if (cubit.loginkey.currentState!.validate()) {
                              cubit.login(
                                  email: cubit.emailController.text,
                                  password: cubit.passwordController.text,
                                  context: context);
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
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Didn't have an account? ",
                              style: TextStyle(fontSize: 20),
                            ),
                            InkWell(
                                onTap: () {
                                  Get.to(() => const register());
                                },
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                      fontSize: 20, color: Color(0xff5ac268)),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
