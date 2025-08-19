import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';

class FoodDrugCheckboxGroup extends StatelessWidget {
  final String typeCard;
  final String? selectedValue;
  final ValueChanged<String> onChanged;
  final String prePareStatus;
  final bool isDisabled;

  const FoodDrugCheckboxGroup({
    super.key,
    required this.typeCard,
    required this.selectedValue,
    required this.onChanged,
    this.isDisabled = false,
    required this.prePareStatus,
  });

  @override
  Widget build(BuildContext context) {
    List<String> baseOptions =
        typeCard == 'Food' ? ['อาหารหมด', 'งดอาหาร'] : ['ยาหมด', 'งดยา'];

    bool isFood = typeCard == 'Food';
    bool notReady = prePareStatus.trim().toLowerCase() != 'ready';
    bool hasGiveAlready = selectedValue?.trim() == 'ให้แล้ว';


    if (!isFood || !notReady || hasGiveAlready) {
      baseOptions.add('ให้แล้ว');
    }

    return Wrap(
      spacing: 16.0,
      children: baseOptions.map((label) {
        bool disableThisOption = isDisabled ||
            (isFood && notReady && label == 'ให้แล้ว' && !hasGiveAlready);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: selectedValue == label,
              activeColor: Colors.teal,
              onChanged: disableThisOption
                  ? null
                  : (bool? newValue) {
                      if (newValue == true) {
                        onChanged(label);
                      } else {
                        onChanged('');
                      }
                    },
            ),
            text(context, label),
          ],
        );
      }).toList(),
    );
  }
}
