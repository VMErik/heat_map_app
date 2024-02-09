import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker_app/components/my_drawer.dart';
import 'package:habit_tracker_app/components/my_habit_tile.dart';
import 'package:habit_tracker_app/components/my_heat_map.dart';
import 'package:habit_tracker_app/database/habit_datatabse.dart';
import 'package:habit_tracker_app/models/habit.dart';
import 'package:habit_tracker_app/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // Leemos los habitos ecistentes en la base de datos
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  // Funciones
  // Controlador para el texto del alert
  final TextEditingController controller = TextEditingController();
  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: controller,
                decoration:
                    const InputDecoration(hintText: 'Crea un nuevo habito'),
              ),
              // Creamos los botones
              actions: [
                MaterialButton(
                  onPressed: () {
                    // obtenemos el nombre del habito
                    String newHabit = controller.text;
                    // Almacenamos en la base de dats
                    context.read<HabitDatabase>().addHabit(newHabit);
                    // Cerramos alert
                    Navigator.pop(context);
                    // Limpiamos el controlador
                    controller.clear();
                  },
                  child: const Text('Guardar'),
                ),
                MaterialButton(
                  onPressed: () {
                    // Cerramos alert
                    Navigator.pop(context);
                    // Limpiamos el controlador
                    controller.clear();
                  },
                  child: const Text('Cancelar'),
                )
              ],
            ));
  }

  void checkHabitOff(bool? value, Habit habit) {
    if (value != null) {
      // Con el read, hacemos acciones dentro de nuestro provider
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  void editHabitBox(Habit habit) {
// establecemos el controlador el texto del habito seleccinado
    controller.text = habit.name;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: controller,
                decoration:
                    const InputDecoration(hintText: 'Crea un nuevo habito'),
              ),
              // Creamos los botones
              actions: [
                MaterialButton(
                  onPressed: () {
                    // obtenemos el nombre del habito
                    String newHabit = controller.text;
                    // Almacenamos en la base de dats
                    context
                        .read<HabitDatabase>()
                        .updateHabitname(habit.id, newHabit);
                    // Cerramos alert
                    Navigator.pop(context);
                    // Limpiamos el controlador
                    controller.clear();
                  },
                  child: const Text('Guardar'),
                ),
                MaterialButton(
                  onPressed: () {
                    // Cerramos alert
                    Navigator.pop(context);
                    // Limpiamos el controlador
                    controller.clear();
                  },
                  child: const Text('Cancelar'),
                )
              ],
            ));
  }

  void deleteHabitBox(Habit habit) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Estas seguro de eliminar este habito'),
              // Creamos los botones
              actions: [
                MaterialButton(
                  onPressed: () {
                    // Almacenamos en la base de dats
                    context.read<HabitDatabase>().deleteHabit(habit.id);
                    // Cerramos alert
                    Navigator.pop(context);
                  },
                  child: const Text('Eliminar'),
                ),
                MaterialButton(
                  onPressed: () {
                    // Cerramos alert
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                )
              ],
            ));
  }

// ******************************************

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNewHabit();
        },
        backgroundColor: colorScheme.tertiary,
        child: const Icon(Icons.add),
      ),
      body: ListView(children: [_buildheatMap(), _buildHabitList()]),
    );
  }

  // Construimos el heat map
  Widget _buildheatMap() {
    // Cnsulta habitos
    final habitDatabase = context.watch<HabitDatabase>();
    // Habitos actuales
    List<Habit> currenHabits = habitDatabase.currentHabits;

    return FutureBuilder<DateTime?>(
        future: habitDatabase.getFirstLaunchDate(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyHeatMap(
                startDate: snapshot.data!,
                datasets: prepareHeatMapDataSet(currenHabits));
            // Si hay info, construimos el heatmap
          }
          // Si no hay nada, no respondemos
          else {
            return Container();
          }
        });
  }

  // Construimos la lista de habitos
  Widget _buildHabitList() {
    // Estamos pendiente de nuestro provider
    // Con el watch, escuchamos acciones del provider
    final habitDatabase = context.watch<HabitDatabase>();
    // OObtenemos nuestra lista de habitos
    List<Habit> currenHabits = habitDatabase.currentHabits;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
        itemCount: currenHabits.length,
        itemBuilder: (context, index) {
          // Obtenemos el habito
          final habit = currenHabits[index];
          // Verificamos si ya se hizo hoy
          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
          // Retornamos el control
          return MyHabitTile(
            isCompleted: isCompletedToday,
            text: habit.name,
            onChanged: (value) => checkHabitOff(value, habit),
            editHabit: (value) => editHabitBox(habit),
            deleteHabit: (value) => deleteHabitBox(habit),
          );
        });
  }
}
