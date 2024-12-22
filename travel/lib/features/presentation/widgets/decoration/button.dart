import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text; 

  const CustomButton({
    super.key,
    required this.text, 
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        elevation: 3.0,
        backgroundColor: const Color.fromRGBO(218, 172, 172, 1),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onPressed: () {}, 
    );
  }
}
