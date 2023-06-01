import 'package:flutter/material.dart';

import 'size_fade_switcher.dart';

class TextInputField extends StatelessWidget {
  final String hintText;
  final void Function(String value) onChanged;
  final String? errorText;
  final bool obscureText;

  const TextInputField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.errorText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFD0D0D0),
              width: 1,
            ),
          ),
          child: TextField(
            onChanged: onChanged,
            obscureText: obscureText,
            style: const TextStyle(
              fontSize: 16,
              height: 1.2,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFFC2C2C2),
              ),
            ),
          ),
        ),
        SizeFadeSwitcher(
          child: errorText == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Text(
                    errorText!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
        )
      ],
    );
  }
}
