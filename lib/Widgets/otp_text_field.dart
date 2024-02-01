import 'package:flutter/material.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';

class Otp_Text_Field extends StatelessWidget {
  final OtpFieldControllerV2 otpController;
  final bool visibulity;
  final Function(String) onComplete;
  const Otp_Text_Field(
      {super.key,
      required this.otpController,
      required this.visibulity,
      required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibulity,
      child: OTPTextFieldV2(
        controller: otpController,
        length: 4,
        width: MediaQuery.of(context).size.width,
        textFieldAlignment: MainAxisAlignment.spaceAround,
        fieldWidth: 45,
        fieldStyle: FieldStyle.box,
        outlineBorderRadius: 15,
        style: TextStyle(fontSize: 17),
        onChanged: (pin) {
          print("Changed: " + pin);
        },
        onCompleted: (pin) {
          onComplete(pin);
        },
      ),
    );
  }
}
