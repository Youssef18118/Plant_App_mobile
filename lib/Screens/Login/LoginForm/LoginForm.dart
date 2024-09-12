import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_app/Screens/Login/cubit/login_cubit.dart';

class CustomFormField extends StatelessWidget {
  final double height;
  final String text;
  final bool isPasswordField;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomFormField({
    required this.height,
    required this.text,
    required this.isPasswordField,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: height * 0.091,
          child: TextFormField(
            controller: controller,
            obscureText: isPasswordField && !cubit.isPasswordVisible,
            validator: validator,
            decoration: InputDecoration(
              suffixIcon: isPasswordField
                  ? IconButton(
                      icon: Icon(
                        cubit.isPasswordVisible
                            ? CupertinoIcons.eye_slash
                            : CupertinoIcons.eye,
                      ),
                      onPressed: () {
                        cubit.togglePasswordVisibility();
                      },
                    )
                  : null,
              labelText: text,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 190, 189, 189),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 190, 189, 189),
                  width: 1.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
