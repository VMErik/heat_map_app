import 'package:flutter/material.dart';
import 'package:habit_tracker_app/models/app_settings.dart';
import 'package:habit_tracker_app/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;
  // CONFIGURACION
  // **************************************
  // INICIALIZACION
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
        // Mandamos nuestros Schemas, que son los que creamos
        [
          HabitSchema,
          AppSettingsSchema
        ]
        // Mandamos nuestro directorio de la aplicacion
        ,
        directory: dir.path);
  }

  // ALMACENAMIENTO DE LA PRIMER FECHA
  Future<void> saveFirstLaunchDate() async {
    // Consultamos si ya hay una fecha inicial, y en caso de que no la insertamos
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // OBTENEMOS LA PRIMER FECHAS
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  // OPERACIONES CRUD
  // **************************************
  // LISTA DE TODOS
  final List<Habit> currentHabits = [];
  // CREACION
  Future<void> addHabit(String habitName) async {
// Craemos nuestro habito
    final habit = Habit()..name = habitName;
    // Lo guardamos en la base de datos
    await isar.writeTxn(() => isar.habits.put(habit));
    // Consultamos los habitos
    readHabits();
  }

  // CONSULTA
  Future<void> readHabits() async {
    // Consultamos en la base de datos
    List<Habit> fetchHabits = await isar.habits.where().findAll();
    // Limpiamos la lista
    currentHabits.clear();
    // Relleanmos nuevamente
    currentHabits.addAll(fetchHabits);
    // Notificamos a la UI
    notifyListeners();
  }

  // UPDATE , TERMINADO - ABIERTO
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // Buscamos
    final habit = await isar.habits.get(id);
    // Actualizamos
    if (habit != null) {
      await isar.writeTxn(() async {
        // Si el habito se ha realizado, agregaos la fecha del dia dehoy
        // En caso contrario eliminamos la fecha de hoy de la lista
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now();
          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        } else {
          habit.completedDays.removeWhere((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day);
        }
        await isar.habits.put(habit);
      });
    }
    // Hacemos lectura nuevamente
    readHabits();
  }

  // UPDATE NOMBRE DE HABITO
  Future<void> updateHabitname(int id, String newName) async {
    // Buscamos
    final habit = await isar.habits.get(id);
    if (habit != null) {
      // Actualizamos
      habit.name = newName;
      await isar.writeTxn(() async{
        await isar.habits.put(habit);
      });
    }
    // Consultamos nuevamente
    readHabits();
  }

  // DELETE
  Future<void> deleteHabit(int id) async {
    // Hacemos el delete
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    // Consultamos nuevamente
    readHabits();
  }
}
