import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_app/Screens/add%20your%20plant/cubit/add_plant_cubit.dart';
import 'add_your_plant_Widgets.dart';

class AddYourPlantScreen extends StatefulWidget {
  AddYourPlantScreen({super.key});

  @override
  State<AddYourPlantScreen> createState() => _AddYourPlantScreenState();
}

class _AddYourPlantScreenState extends State<AddYourPlantScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final cubit = context.read<AddPlantCubit>();

    return BlocBuilder<AddPlantCubit, AddPlantState>(
      builder: (context, state) {
        return Scaffold(
          appBar: Appbar(height, context, width),
          body: Padding(
            padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
            child: form(cubit, height, width, context),
          ),
        );
      },
    );
  }
}
