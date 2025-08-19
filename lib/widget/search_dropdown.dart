import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class Dropdown {
  static Widget lModel<T>({
    required T? value,
    required List<DropdownMenuItem<T>>? items,
    required Function(T?) onChanged,
    required TextEditingController tController,
    required bool isSelect,
    required String validator,
    required BuildContext context,
    required double width,
    double height = 50,
    String? hintLabel,
    String? labelInSearch,
  }) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: hintLabel ?? '',
          floatingLabelBehavior: value == null
              ? FloatingLabelBehavior.never
              : FloatingLabelBehavior.always,
          labelStyle: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 1, 99, 87),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            isExpanded: true,
            value: value,
            hint: value == null
                ? Text(
                    hintLabel ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 1, 99, 87),
                    ),
                  )
                : null,
            items: items
                ?.map(
                  (DropdownMenuItem<T> item) => DropdownMenuItem<T>(
                    value: item.value,
                    child: DefaultTextStyle.merge(
                      style: const TextStyle(
                          fontSize: 12, color: Color.fromARGB(255, 1, 99, 87)),
                      child: item.child,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              onChanged(value);
            },
            buttonStyleData: ButtonStyleData(
              padding: EdgeInsets.zero,
              height: height,
              width: width,
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 200,
            ),
            menuItemStyleData: MenuItemStyleData(
              height: height,
            ),
            dropdownSearchData: DropdownSearchData(
              searchInnerWidgetHeight: height,
              searchController: tController,
              searchInnerWidget: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: tController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    hintText: labelInSearch ?? '- ค้นหา -',
                    hintStyle: const TextStyle(
                        fontSize: 12, color: Color.fromARGB(255, 1, 99, 87)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: const TextStyle(
                      fontSize: 12, color: Color.fromARGB(255, 1, 99, 87)),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value
                    .toString()
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                tController.clear();
              }
            },
          ),
        ),
      ),
    );
  }

  static field({required String type}) {}
}
