import 'package:flutter/material.dart';

class TextFieldGeneral extends StatelessWidget {
  final String labelCaja;
  final String? hintText;
  final Function(String) onChanged;
  final TextInputType? keyboardType;
  final IconData icon;
  final bool obscureText;
  final TextEditingController _controller;

  const TextFieldGeneral(
      {super.key,
      required this.labelCaja,
      this.hintText,
      required this.onChanged,
      this.keyboardType,
      required this.icon,
      this.obscureText = false,
      required TextEditingController controller})
      : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: TextField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          controller: _controller,
          decoration: InputDecoration(
              prefixIcon: Icon(icon), labelText: labelCaja, hintText: hintText),
          onChanged: onChanged,
        ));
  }

  String getText() {
    return _controller.text;
  }
}
