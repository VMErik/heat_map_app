import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  final bool isCompleted;
  final String text;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext?)? editHabit;
  final void Function(BuildContext?)? deleteHabit;


  const MyHabitTile(
      {super.key,
      required this.isCompleted,
      required this.text,
      this.onChanged,
      this.editHabit, this.deleteHabit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal:25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // Opcion de editar
            SlidableAction(
              onPressed: editHabit,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(8),
            ),
            // Opcion de eliminar
            SlidableAction(
              onPressed: deleteHabit,
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(8),
            )
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              onChanged!(!isCompleted);
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8)),
            // Le damos espacio hacia dentro del contenido
            padding: const EdgeInsets.all(15),
         
            child: ListTile(
              title: Text(text , style: TextStyle(
                color: isCompleted ? Colors.white : Theme.of(context).colorScheme.inversePrimary
              ),),
              leading: Checkbox(
                activeColor: Colors.green,
                value: isCompleted,
                // Hacemos referencia a la funcion que se ejecutara
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
