// lib/screens/anamnese/widgets/custom_widgets.dart

import 'package:flutter/material.dart';

/// Widget para grupos de checkboxes onde "nenhuma" é mutuamente exclusiva com as demais.
class MutuallyExclusiveCheckboxGroup extends StatefulWidget {
  final List<String> items; // deve incluir "nenhuma"
  final List<String> selectedItems;
  final ValueChanged<List<String>> onSelectionChanged;
  final String title;

  const MutuallyExclusiveCheckboxGroup({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
    this.title = '',
  });

  @override
  State<MutuallyExclusiveCheckboxGroup> createState() => _MutuallyExclusiveCheckboxGroupState();
}

class _MutuallyExclusiveCheckboxGroupState extends State<MutuallyExclusiveCheckboxGroup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty)
          Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ...widget.items.map((item) => CheckboxListTile(
              title: Text(item),
              value: widget.selectedItems.contains(item),
              onChanged: (bool? value) {
                if (value == null) return;

                List<String> newSelection = List<String>.from(widget.selectedItems);

                if (item == 'nenhuma') {
                  if (value) {
                    // Selecionar "nenhuma" → desmarca tudo
                    newSelection = ['nenhuma'];
                  } else {
                    // Desmarcar "nenhuma" → deixa vazio
                    newSelection.remove('nenhuma');
                  }
                } else {
                  if (value) {
                    // Selecionar outro → remove "nenhuma" e adiciona este
                    newSelection.remove('nenhuma');
                    newSelection.add(item);
                  } else {
                    // Desmarcar outro → só remove este
                    newSelection.remove(item);
                  }
                }

                widget.onSelectionChanged(newSelection);
              },
            )),
      ],
    );
  }
}

/// Widget para perguntas Sim/Não com botões lado a lado
class YesNoButtonGroup extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool> onChanged;
  final String label;

  const YesNoButtonGroup({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            TextButton.icon(
              onPressed: () => onChanged(true),
              icon: Icon(Icons.check_circle, color: value == true ? Colors.green : Colors.grey),
              label: const Text('Sim'),
            ),
            TextButton.icon(
              onPressed: () => onChanged(false),
              icon: Icon(Icons.cancel, color: value == false ? Colors.red : Colors.grey),
              label: const Text('Não'),
            ),
          ],
        ),
      ],
    );
  }
}