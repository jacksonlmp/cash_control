// lib/ui/widgets/custom_form.dart
import 'package:flutter/material.dart';
import 'custom_button.dart';

class CustomForm extends StatelessWidget {
  final List<Widget> formFields;
  final String buttonText;
  final bool isLoading;
  final Function onSubmit;

  const CustomForm({
    required this.formFields,
    required this.buttonText,
    required this.isLoading,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...formFields,
          const SizedBox(height: 16),
          CustomButton(
            isLoading: isLoading,
            text: buttonText,
            onPressed: () => onSubmit(),
          ),
        ],
      ),
    );
  }
}
