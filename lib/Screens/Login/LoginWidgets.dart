import 'package:flutter/material.dart';
import 'package:plant_app/const.dart';
Text smallText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.grey[400]),
    );
  }

  Container LoginButton(double height, String service, {IconData? chosenIcon, String? image}) {
    return Container(
      width: double.infinity,
      height: height * 0.06,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 190, 189, 189), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (chosenIcon != null) Icon(chosenIcon, size: 32,),
          if (image != null) ...[
            SizedBox(
              width: 22,
              height: 22,
              child: Image.asset(imagePath +"$image"),
            ),
          ],
          const SizedBox(width: 10,),
          Text(
            "Log in with $service",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: "Noyh Regular"),
          ),
        ],
      ),
    );
  }