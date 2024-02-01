import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

String? slectetdValue;
class DropDownWidget extends StatelessWidget {
  final List<String> items;
  final String dropBtnName;
  final Function(String)? onSelected;
  const DropDownWidget({super.key, required this.items, required this.dropBtnName, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              dropBtnName,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            items: items
                .map((String item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ))
                .toList(),
            value: slectetdValue,
            onChanged: (String? value) {
              onSelected!(value!);
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              width: 140,
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
          ),
        ),
      ),
    );
  }
}


