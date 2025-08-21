import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

class PhoneInput extends StatelessWidget {
  final void Function(String e164)? onValidChanged;
  const PhoneInput({super.key, this.onValidChanged});

  @override
  Widget build(BuildContext context) {
    return PhoneFormField(
      // UI-only default: India, empty local number
      initialValue: const PhoneNumber(isoCode: IsoCode.IN, nsn: ''),
      decoration: const InputDecoration(
        labelText: 'Phone number',
        border: OutlineInputBorder(),
      ),
      countrySelectorNavigator: const CountrySelectorNavigator.bottomSheet(),
      // If your version expects (PhoneNumber?) -> String?
      validator: (p) => (p == null || p.nsn.trim().length < 8)
          ? 'Enter a valid phone number'
          : null,
      onChanged: (p) {
        if (p == null) return;
        if (p.nsn.trim().length >= 8) {
          onValidChanged?.call('+${p.countryCode}${p.nsn}');
        }
      },
    );
  }
}